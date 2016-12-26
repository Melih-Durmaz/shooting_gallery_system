-- shooter
insert into shooter values (1, 'jrr tolkein', '03-01-1892', '+27 999 999 9999', true);
insert into shooter values (2, 'peter jackson', '01-01-1950', '+64 999 999 9999', true);
insert into shooter values (3, 'martin freeman', '04-01-1970', '+44 999 999 9999', true);
select * from shooter;

-- field
insert into field (nm, lctn, max_range) values ('legolas-field', 'Lothlorien', 200.0);
insert into field (nm, lctn, max_range) values ('thorin-field', 'Erebor', 50.0);
insert into field (nm, lctn, max_range) values ('aragorn-field', 'Minas Tirith', 100.0);
select * from field;

-- gun_type
insert into gun_type (nm) values ('bow');
insert into gun_type (nm) values ('ax');
insert into gun_type (nm) values ('sword');
insert into gun_type (nm) values ('spear');
select * from gun_type;

-- uses_field
insert into uses_field values (1,1);
insert into uses_field values (2,2);
insert into uses_field values (3,1);
insert into uses_field values (3,2);
insert into uses_field values (3,3);
insert into uses_field values (4,1);
select * from uses_field;

-- gun
insert into gun (serial_number, nm, gun_type_id) values('abc123', 'turkish-bow', 1);
insert into gun (serial_number, nm, gun_type_id) values('abc321', 'cronos-ax', 2);
insert into gun (serial_number, nm, gun_type_id) values('ghi123', 'excalibur', 3);
insert into gun (serial_number, nm, gun_type_id) values('def123', 'zeus-spear', 4);
insert into gun (serial_number, nm, gun_type_id) values('def456', 'gandalf-stick', 4);
select * from gun;

-- shot
insert into shot values(2,1,1, 50.0, '2016-12-27 00:30:00.000000', '2016-12-27 01:30:00.000000');
insert into shot values(1,2,2, 75.5, '2016-12-27 00:00:00.000000', '2016-12-27 01:00:00.000000');
insert into shot values(1,3,2, 75.5, '2016-12-28 00:00:00.000000', '2016-12-28 01:00:00.000000');
insert into shot values(2,3,3, 75.5, '2016-12-28 01:00:00.000000', '2016-12-28 02:00:00.000000');
insert into shot values(2,3,3, 75.5, '2016-12-29 01:00:00.000000', '2016-12-29 02:00:00.000000');
select * from shot;

-- exception creators
insert into shot values(2,3,3, 75.5, '2016-12-28 00:00:00.000000', '2016-12-28 02:00:00.000000'); -- scheduling conflict
insert into shot values(2,3,1, 75.5, '2016-12-28 00:00:00.000000', '2016-12-28 02:00:00.000000'); -- hermione shooter
insert into shot values(3,3,2, 75.5, '2016-12-29 00:00:00.000000', '2016-12-29 02:00:00.000000'); -- busy gun 



