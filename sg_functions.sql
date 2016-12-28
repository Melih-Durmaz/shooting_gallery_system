-- selecting schedule field id given
create or replace function get_schedule(fi schedule.field_id%type) 
	returns table(start_date schedule.start%type, stop_date schedule.stop%type) as $$
begin
	return query select start, stop from schedule where field_id=fi;
end;
$$ language plpgsql;

-- selecting shots shooter id given
create or replace function get_shots_from_shooter(ss shot.shooter_ssn%type)
	returns table(gun_id int, field_id int, success_percentage int, start_date timestamp, stop_date timestamp) as $$
begin
	return query select gun_id, field_id, success_percentage, start_date, stop_date from shot
	where shooter_ssn=ss;
end;
$$ language plpgsql;

-- selecting shots field id given
create or replace function get_shots_from_field(fi shot.field_id%type)
	returns table(shooter_id int, shooter_ssn numeric(10),gun_id int, success_percentage int, start_date timestamp, stop_date timestamp) as $$
begin
	return query select shooter_id, shooter_ssn, gun_id, success_percentage, start_date, stop_date from shot
	where field_id=fi;
end;
$$ language plpgsql;

-- increasing ammo
create or replace function increase_ammo(gi gun_type.id%type) returns void as $$
declare
	ammo float;
begin
	select into ammo ammo_percentage from gun_type where id in (select gun_type_id from gun where id=gun_id);
	if ammo<=90 then 
		update gun_type set ammo_percentage=ammo_percentage+10.0;
	else
		raise exception 'Ammo is already full';
	end if;
end;
$$ language plpgsql;

-- selecting fields gun id given
create or replace function get_fields_from_gun(gi gun.id%type) 
	returns table(id int, nm varchar(20)) as $$
begin
	return query select f.id, f.nm from field f, gun g, uses_field uf  
	where g.gun_type_id=uf.gun_type_id and uf.field_id=f.id and g.gun_type_id=gi; 
end;
$$ language plpgsql;


-- selecting guns field id given
create or replace function get_guns_from_field(fi field.id%type)
	returns table(id int, nm varchar(20)) as $$
begin
	return query select g.id, g.nm from gun g, field f, uses_field uf
	where  g.gun_type_id=uf.gun_type_id and uf.field_id=f.id and f.id = fi;
end;
$$ language plpgsql;