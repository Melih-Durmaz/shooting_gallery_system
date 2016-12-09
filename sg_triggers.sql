--ADD EXCEPTIONS FOR ALL
--update shooter success_percentage trigger
create or replace function success_per_update() returns trigger as $success_per_update$
begin
	update shooter set shot_success = (success_percentage+shot_success*shot_count)/(shot_count+1),
	shot_count=shot_count+1
	where id=shooter_id and ssn=shooter_ssn; 
end;
$success_per_update$ language plpgsql;

create trigger success_per_update after insert on shot for each row execute procedure success_per_update();


--update field throng trigger
create or replace function field_throng_update() returns trigger as $field_throng_update$
declare
	val int
begin
	if TG_OP='delete' then
		val:=-1;
	elsif TG_OP='insert' then
		val:=1;
	end if;
	
	update field set throng = throng + (stop-start)*10*val
	where id=field_id; 
end;
$field_throng_update$ language plpgsql;

create trigger field_throng_update after insert or delete on schedule for each row execute procedure field_throng_update();

--control already scheduled trigger
create or replace function already_scheduled() returns trigger as $already_scheduled$
declare 
	cur cursor for select * from get_schedule(field_id);
	
begin
	for rec in cur loop
		if start_date<rec.stop or stop_date>rec.start then
			raise exception 'Scheduling conflict appears. Try for another day or time-range.';
			return null;
		end if;
	end loop;
	
end;
$already_scheduled$ language plpgsql;

create trigger already_scheduled before insert on shot for each row execute procedure already_scheduled();

--control shot time
create or replace function control_shot_time() returns trigger as $control_shot_time$
begin
	if start_date.NEW<now() or stop_date.NEW<now() then
		raise exception 'You can not add shot for before this time';
		return null;
	elsif start_date>stop_date then
		return null;
	end if;
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
			return null;
		end if;
	end loop;
end;
$control_shot_gun_busy$ language plpgsql;

create trigger control_shot_gun_busy before insert on shot for each row execute procedure control_shot_gun_busy();

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
end;
$clean_dead_schedules$ language plpgsql;

create trigger clean_dead_schedules before insert on shot for each row execute procedure clean_dead_schedules();

--clean deleted shoter's shots trigger
create or replace function clean_shooter_shots() returns trigger as $clean_shooter_shots$
begin
	delete from shot where shooter_id=id and shooter_ssn=ssn;
end;
$clean_shooter_shots$ language plpgsql;

create trigger clean_shooter_shots after delete on shooter for each row execute procedure clean_shooter_shots();

--update gun_type ammo trigger
create or replace function update_ammo() returns trigger as $update_ammo$
begin
	update gun_type set ammo_percentage = ammo_percentage-10.0
	where id in (select gun_type_id from gun where id=gun_id);
end;
$update_ammo$ language plpgsql;

create trigger update_ammo after insert on shot for each row execute procedure update_ammo();

--control gun_type ammo empty
create or replace function is_ammo_empty() returns trigger as $is_ammo_empty$
declare
	ammo float;
begin
	select into ammo ammo_percentage from gun_type where id in (select gun_type_id from gun where id=gun_id);
	if amma=0 then
		raise exception 'Ammo is empty. Shooter cannot shot';
		return null;
	end if;
end;
$is_ammo_empty$ language plpgsql; 

create trigger is_ammo_empty before insert on shot for each row execute procedure is_ammo_empty();


