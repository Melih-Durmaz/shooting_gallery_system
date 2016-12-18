--update shooter success_percentage trigger
create or replace function success_per_update() returns trigger as $success_per_update$
begin
	update shooter set shot_success = (success_percentage+shot_success*shot_count)/(shot_count+1),
	shot_count=shot_count+1
	where ssn=shooter_ssn; 
	return null;
end;
$success_per_update$ language plpgsql;

create trigger success_per_update after insert on shot for each row execute procedure success_per_update();


--update field throng trigger
create or replace function field_throng_update() returns trigger as $field_throng_update$
declare
	val int;
begin
	if TG_OP='delete' then
		val:=-1;
	elsif TG_OP='insert' then
		val:=1;
	end if;
	
	update field set throng = throng + (stop-start)*10*val
	where id=field_id; 
	return null;
end;
$field_throng_update$ language plpgsql;

create trigger field_throng_update after insert or delete on schedule for each row execute procedure field_throng_update();


--control already scheduled trigger
create or replace function already_scheduled() returns trigger as $already_scheduled$
declare 
	cur cursor for select * from get_schedule(NEW.field_id);
	
begin
	for rec in cur loop
		if NEW.start_date<rec.stop or NEW.stop_date>rec.start then
			raise exception 'Scheduling conflict.' 
				using hint='Try for another day or time-range.';
		end if;
	end loop;
	return null;
end;
$already_scheduled$ language plpgsql;

create trigger already_scheduled before insert on shot for each row execute procedure already_scheduled();

--control shot time
create or replace function control_shot_time() returns trigger as $control_shot_time$
begin
	if start_date.NEW<now() or stop_date.NEW<now() then
		raise exception 'Time mess.'
			using hint = 'You can not add shot for before this time';
	elsif start_date>stop_date then
		raise exception 'Time mess.'
			using hint = 'Start date can not be after stop time';
	end if;
	return null;
end;
$control_shot_time$ language plpgsql;

create trigger control_shot_time before insert on shot for each row execute procedure control_shot_time();

--control shot gun if busy for this time
create or replace function control_shot_gun_busy() returns trigger as $control_shot_gun_busy$ 
declare
	cur cursor for select * from shot s where s.start_date<stop_date and s.stop_date>start_date;
begin
	for rec in cur loop
		if rec.gun_id=gun_id then
			raise exception 'Busy gun.'
				using hint = 'Another shooter uses this gun for this time.';
		end if;
	end loop;
	return null;
end;
$control_shot_gun_busy$ language plpgsql;

create trigger control_shot_gun_busy before insert on shot for each row execute procedure control_shot_gun_busy();

--control shooter can not be in many places at same time
create or replace function control_hermione_shooter() returns trigger as $control_hermione_shooter$
declare
	cur cursor for select * from shot s where s.shooter_ssn=ssn;
begin
	for rec in cur loop
		if start_date<rec.stop_date or stop_date>rec.start_date then
			raise exception 'Hermione shooter'
				using hint = 'Shooter can not be in many places at same time';
		end if;
	end loop;
	return null;
end;
$control_hermione_shooter$ language plpgsql;

create trigger control_hermione_shootter before insert on shot for each row execute procedure control_hermione_shooter();

--clean dead schedules trigger
create or replace function clean_dead_schedules() returns trigger as $clean_dead_schedules$
declare
	cur cursor for select * from schedule;

begin
	for rec in cur loop
		if rec.stop<now() then
			delete from schedule where field_id=rec.field_id and start=rec.start and stop=rec.stop;
		end if;
	end loop;
	return null;
end;
$clean_dead_schedules$ language plpgsql;

create trigger clean_dead_schedules before insert on shot for each row execute procedure clean_dead_schedules();

--clean deleted shoter's shots trigger
create or replace function clean_shooter_shots() returns trigger as $clean_shooter_shots$
begin
	delete from shot where shooter_ssn=OLD.ssn;
	return null;
end;
$clean_shooter_shots$ language plpgsql;

create trigger clean_shooter_shots after delete on shooter for each row execute procedure clean_shooter_shots();

--update gun_type ammo trigger
create or replace function update_ammo() returns trigger as $update_ammo$
begin
	update gun_type set ammo_percentage = ammo_percentage-10.0
	where id in (select gun_type_id from gun where id=gun_id);
	return null;
end;
$update_ammo$ language plpgsql;

create trigger update_ammo after insert on shot for each row execute procedure update_ammo();

--control gun_type ammo empty
create or replace function is_ammo_empty() returns trigger as $is_ammo_empty$
declare
	ammo float;
begin
	select into ammo ammo_percentage from gun_type where id in (select gun_type_id from gun where id=gun_id);
	if ammo=0 then
		raise exception 'Empty ammo.'
			using hint = 'Refill ammo before adding shot';
	end if;
	return null;
end;
$is_ammo_empty$ language plpgsql; 

create trigger is_ammo_empty before insert on shot for each row execute procedure is_ammo_empty();



--control gun - field match
create or replace function control_gun_field_match() returns trigger as $gun_field_match$
declare
	cur cursor for select field_id from uses_field uf, gun g
		where  g.id = NEW.gun_id and uf.gun_type_id = g.gun_type_id 
		and uf.field_id = NEW.field_id;
begin
	for rec in cur loop
		if rec.field_id != NEW.field_id then
			raise exception 'Unmatchable gun-field.'
				using hint = 'Try another gun or field for shot';
		end if;
	end loop;
	return null;
end;
$gun_field_match$ language plpgsql;

create trigger control_gun_field_match before insert on shot for each row execute procedure control_gun_field_match();
