﻿-- shooter views
create view shooter_ob_name as select * from shooter where member=true order by name_surname;
create view shooter_ob_success as select * from shooter where member=true order by shot_success;
create view shooter_all_ob_member as select * from shooter where member=true order by member;
create view shooter_not_member as select * from shooter where member=false;

-- shooters for combo box
create view shooter_combo as select ssn, name_surname from shooter order by name_surname;

-- field views
create view field_ob_name as select * from field order by nm;
create view field_ob_id as select * from field order by id;
create view field_ob_throng as select * from field order by throng desc;

-- fields for combo box
create view field_combo as select id, nm from field;

-- gun_type views
create view gun_type_ob_name as select * from gun_type order by nm;
create view gun_type_ob_id as select * from gun_type order by id;
create view gun_type_ob_ammo_percentage as select * from gun_type order by ammo_percentage;

-- gun_type combo
create view gun_type_combo as select id, nm from gun_type;

-- gun views
create view gun_ob_serial_number as select g.id, g.serial_number, g.nm as gnm, gt.nm as gtnm
	from gun g, gun_type gt where g.gun_type_id = gt.id order by g.serial_number;
create view gun_ob_id as select g.id, g.serial_number, g.nm as gnm, gt.nm as gtnm
	from gun g, gun_type gt where g.gun_type_id = gt.id order by g.id;
create view gun_ob_name as select g.id, g.serial_number, g.nm as gnm, gt.nm as gtnm 
	from gun g, gun_type gt where g.gun_type_id = gt.id order by g.nm;

-- guns for combo box
create view gun_combo as select * from gun;

-- shot views
create view shot_ob_shooter_ssn as select sr.name_surname, g.nm as gnm, f.nm as fnm, s.success_percentage, s.start_date, s.stop_date 
	from field f, gun g, shooter sr, shot s 
	where sr.member=true and s.shooter_ssn = sr.ssn
	and s.gun_id = g.id and s.field_id = f.id order by s.shooter_ssn;
create view shot_ob_start_date as select sr.name_surname, g.nm as gnm, f.nm as fnm, s.success_percentage, s.start_date, s.stop_date 
	from field f, gun g, shooter sr, shot s 
	where sr.member=true and s.shooter_ssn = sr.ssn
	and s.gun_id = g.id and s.field_id = f.id order by s.start_date;
create view shot_ob_success_percentage as select sr.name_surname, g.nm as gnm, f.nm as fnm, s.success_percentage, s.start_date, s.stop_date 
	from field f, gun g, shooter sr, shot s 
	where sr.member=true and s.shooter_ssn = sr.ssn
	and s.gun_id = g.id and s.field_id = f.id order by s.success_percentage;
create view shot_by_not_member as select sr.name_surname, g.nm as gnm, f.nm as fnm, s.success_percentage, s.start_date, s.stop_date 
	from field f, gun g, shooter sr, shot s 
	where sr.member=false and s.shooter_ssn = sr.ssn
	and s.gun_id = g.id and s.field_id = f.id ;
