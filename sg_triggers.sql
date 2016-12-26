-- control shot time---------------------------------------------------------------------------------------
create or replace function control_shot_time() returns trigger as $control_shot_time$
begin
	if NEW.start_date<now() or NEW.stop_date<now() then
		raise exception 'Time mess.'
			using hint = 'You can not add shot for before this time';
		return NULL;
	elsif NEW.start_date>NEW.stop_date then
		raise exception 'Time mess.'
			using hint = 'Start date can not be after stop time';
		return NULL;
	elsif NEW.start_date < NEW.stop_date or NEW.start_date > NEW.stop_date then
	else
		raise exception 'Time mess.'
			using hint = 'Start and stop date can not be same';
		return NULL;
	end if;
	raise notice 'control_shot_time';
	return NEW;
end;
$control_shot_time$ language plpgsql;

-- control already scheduled trigger-----------------------------------------------------------------------
create or replace function already_scheduled() returns trigger as $already_scheduled$
declare 
	cur cursor for select * from get_schedule(NEW.field_id);
begin
	for rec in cur loop
		if NEW.start_date<rec.stop_date and NEW.stop_date>rec.start_date then
			raise exception 'Scheduling conflict.' 
				using hint='Try for another day or time-range.';
			return NULL;		
		end if;
	end loop;
	raise notice 'already_scheduled';
	return NEW;
end;
$already_scheduled$ language plpgsql;

-- control gun_type ammo empty----------------------------------------------------------------------------
create or replace function is_ammo_empty() returns trigger as $is_ammo_empty$
declare
	ammo float;
begin
	select into ammo ammo_percentage from gun_type where id in (select gun_type_id from gun where id=NEW.gun_id);
	if ammo=0 then
		raise exception 'Empty ammo.'
			using hint = 'Refill ammo before adding shot';
		return NULL;
	end if;
	raise notice 'is_ammo_empty';
	return NEW;
end;
$is_ammo_empty$ language plpgsql; 

-- control shooter can not be in many places at same time--------------------------------------------------
create or replace function control_hermione_shooter() returns trigger as $control_hermione_shooter$
declare
	cur cursor for select * from shot s where s.shooter_ssn=NEW.shooter_ssn;
begin
	for rec in cur loop
		if NEW.start_date<rec.stop_date and NEW.stop_date>rec.start_date then
			raise exception 'Hermione shooter'
				using hint = 'Shooter can not be in many places at same time';
			return NULL;
		end if;
	end loop;
	raise notice 'control_hermione_shooter';	
	return NEW;
end;
$control_hermione_shooter$ language plpgsql;

-- control gun - field match-----------------------------------------------------------------------------
create or replace function control_gun_field_match() returns trigger as $gun_field_match$
declare
	cur cursor for select field_id from uses_field uf, gun g
		where  g.id = NEW.gun_id and uf.gun_type_id = g.gun_type_id 
		and uf.field_id = NEW.field_id;
	c	int;
begin
	c:=0;
    for rec in cur loop
		if rec.field_id != NEW.field_id then
			raise exception 'Unmatchable gun-field.'
				using hint = 'Try another gun or field for shot';
			return NULL;
		end if;
        c := c+1;
	end loop;
    
    if c = 0 then
    	raise exception 'Unmatchable gun-field.'
			using hint = 'Try another gun or field for shot';
		return NULL;
    end if;
    
	raise notice 'gun_field_match';
	return NEW;
end;
$gun_field_match$ language plpgsql;

-- control shot gun if busy for this time-------------------------------------------------------------------
create or replace function control_shot_gun_busy() returns trigger as $control_shot_gun_busy$ 
declare
	cur cursor for select * from shot s where s.start_date<NEW.stop_date and s.stop_date>NEW.start_date;
begin
	for rec in cur loop
		if rec.gun_id=NEW.gun_id then
			raise exception 'Busy gun.'
				using hint = 'Another shooter uses this gun for this time.';
			return NULL;
		end if;
	end loop;
	raise notice 'control_shot_gun_busy';	
	return NEW;
end;
$control_shot_gun_busy$ language plpgsql;

-- clean dead schedules trigger---------------------------------------------------------------------------
create or replace function clean_dead_schedules() returns trigger as $clean_dead_schedules$
declare
	cur cursor for select * from schedule;

begin
	for rec in cur loop
		if rec.stop<now() then
			delete from schedule where NEW.field_id=rec.field_id and NEW.start=rec.start and NEW.stop=rec.stop;
		end if;
	end loop;
	raise notice 'clean_dead_schedules';
	return NEW;
end;
$clean_dead_schedules$ language plpgsql;

-- update schedule shot by shot trigger----------------------------------------------------------------------
create or replace function insert_schedule() returns trigger as $insert_schedule$
begin 
	insert into schedule values (NEW.field_id, NEW.start_date, NEW.stop_date);
	raise notice 'insert_schedule';	
	return NEW;
end;
$insert_schedule$ language plpgsql;

-- update gun_type ammo trigger---------------------------------------------------------------------------
create or replace function update_ammo() returns trigger as $update_ammo$
begin
	update gun_type set ammo_percentage = ammo_percentage-10.0
	where id in (select gun_type_id from gun where id=NEW.gun_id);
	raise notice 'update_ammo';
	return NEW;
end;
$update_ammo$ language plpgsql;

-- update shooter success_percentage trigger----------------------------------------------------------------
create or replace function success_per_update() returns trigger as $success_per_update$
begin
	update shooter set shot_success = (NEW.success_percentage+shot_success*shot_count)/(shot_count+1),
	shot_count=shot_count+1
	where ssn=NEW.shooter_ssn; 
	raise notice 'success_per_update';
	return NEW;
end;
$success_per_update$ language plpgsql;

-- clean deleted shoter's shots trigger-------------------------------------------------------------------
create or replace function clean_shooter_shots() returns trigger as $clean_shooter_shots$
begin
	delete from shot where shooter_ssn=OLD.ssn;
	raise notice 'clean_shooter_shots';
	return NEW;
end;
$clean_shooter_shots$ language plpgsql;

-- update field throng trigger-----------------------------------------------------------------------------
create or replace function field_throng_update() returns trigger as $field_throng_update$
begin
	update field set throng = throng + extract(hour from (NEW.stop-NEW.start))*10
	where id=NEW.field_id; 
	raise notice 'field_throng_update';
	return NEW;
end;
$field_throng_update$ language plpgsql;


-- clean uses field after delete field----------------------------------------------------------------------
create or replace function clean_uses_field_after_deleted_field() returns trigger as $clean_uses_field_after_deleted_field$
begin
	delete from uses_field where field_id=OLD.id;
end;
$clean_uses_field_after_deleted_field$ language plpgsql;

-- clean uses field after delete gun type-------------------------------------------------------------------
create or replace function clean_uses_field_after_deleted_gun_type() returns trigger as $clean_uses_field_after_deleted_gun_type$
begin
	delete from uses_field where gun_type_id=OLD.id;
end;
$clean_uses_field_after_deleted_gun_type$ language plpgsql;


-- triggers before shot
create trigger control_shot_time before insert on shot for each row execute procedure control_shot_time();
create trigger already_scheduled before insert on shot for each row execute procedure already_scheduled();
create trigger is_ammo_empty before insert on shot for each row execute procedure is_ammo_empty();
create trigger control_hermione_shooter before insert on shot for each row execute procedure control_hermione_shooter();
create trigger control_gun_field_match before insert on shot for each row execute procedure control_gun_field_match();
create trigger control_shot_gun_busy before insert on shot for each row execute procedure control_shot_gun_busy();
create trigger clean_dead_schedules before insert on shot for each row execute procedure clean_dead_schedules();


-- triggers after shot
create trigger insert_schedule after insert on shot for each row execute procedure insert_schedule();
create trigger update_ammo after insert on shot for each row execute procedure update_ammo();
create trigger success_per_update after insert on shot for each row execute procedure success_per_update();


-- triggers after shooter
create trigger clean_shooter_shots after delete on shooter for each row execute procedure clean_shooter_shots();


-- trigggers after schedule
create trigger field_throng_update after insert on schedule for each row execute procedure field_throng_update();

-- triggers after gun_type
create trigger clean_uses_field_after_deleted_gun_type after delete on gun_type for each row execute procedure clean_uses_field_after_deleted_gun_type();

-- triggers after field
create trigger clean_uses_field_after_deleted_field after delete on field for each row execute procedure clean_uses_field_after_deleted_field();