--shooter
insert into shooter values (0000000000, true, '01-01-1950', 'peter', 'antep');
insert into shooter values (0000000001, true, '01-01-1970', 'jackson', 'erzurum');
delete from shooter where ssn=0000000001;
select * from shooter;

--field
insert into field (lctn, nm, max_range) values ('aksaray', 'legolas-field', 200.0);
insert into field (lctn, nm, max_range) values ('davutpaşa', 'gimli-field', 50.0);
insert into field (lctn, nm, max_range) values ('ataşehir', 'aragorn-field', 100.0);
select * from field;

--gun-type
insert into gun_type (nm) values ('bow');
insert into gun_type (nm) values ('ax');
insert into gun_type (nm) values ('sword');
insert into gun_type (nm) values ('spear');
select * from gun_type;

-- gun
insert into gun (serial_number, nm, gun_type_id) values('abc123', 'turkish-bow', 1);
insert into gun (serial_number, nm, gun_type_id) values('def123', 'zeus-spear', 4);
insert into gun (serial_number, nm, gun_type_id) values('def456', 'gandalf-stick', 4);
insert into gun (serial_number, nm, gun_type_id) values('ghi123', 'zülfikar', 3);
insert into gun (serial_number, nm, gun_type_id) values('abc321', 'cronos-ax', 2);
select * from gun;