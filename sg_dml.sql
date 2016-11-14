-- shooter : id, ssn, birthdate, name, communication(where lives)
-- truncate table shooter;
insert into shooter values(1, 0000000001, '19410909', 'Dennis Ritchie', 'USA-New York');
insert into shooter values(2, 0000000002, '19430204', 'Keno Thompson', 'USA-Lousiana');
insert into shooter values(3, 0000000003, '19691128', 'Linus Torvalds', 'Finland-Helsinki');
insert into shooter values(4, 0000000004, '19530316', 'Richard Stallman', 'USA-New York');
insert into shooter values(0, 0000000005, '19501230', 'Bjarne Stroustrup', 'Denmark-Aarhus');
insert into shooter values(0, 0000000006, '19551028', 'Bill Gates', 'USA-Washington');
insert into shooter values(0, 0000000007, '19550519', 'James Gosling', 'Canada-Calgary');

-- field : id, location, name, schedule, platform count, max shooting range, maintenance info
-- truncate table field;
insert into field values(0, 'address 1', 'hand-gun field', 'schedule 1', 10, 50.0, '1');
insert into field values(1, 'address 1', 'submachine-gun field', 'schedule 2', 5, 75.0, '2');
insert into field values(2, 'address 2', 'submachine-gun field', 'schedule 1', 10, 75.0, '2');
insert into field values(3, 'address 3', 'tank field', 'schedule 3', 2, 300.0, '5');
insert into field values(4, 'address 2', 'machine-gun field', 'schedule 4', 10, 100.0, '2');
insert into field values(5, 'address 4', 'sniper-rifle field', 'schedule 5', 7, 200.0, '1');
insert into field values(6, 'address 4', 'rifle field', 'schedule 1', 15, 100.0, '1');

-- gun_type : id, name, charge, field id, ammo
-- truncate table gun_type;
insert into gun_type values(0, 'hand-gun', 25.0, 0, 100.0);
insert into gun_type values(1, 'submachine-gun', 30.0, 1, 75.0); -- problem with inserting multi field id
insert into gun_type values(2, 'machine-gun', 35.0, 4, 75.0);
insert into gun_type values(3, 'tank', 200.0, 3, 50.0);
insert into gun_type values(4, 'rifle', 40.0, 6, 100.0);
insert into gun_type values(5, 'sniper-rifle', 50.0, 5, 80.0);

-- gun : id, serial number, name, gun type id, maintenance info
-- truncate table gun;
insert into gun values (0, 'A1', 'Ballester-Molina', 0, '1');
insert into gun values (1, 'A2', 'Baretta 3032 Tomcat', 0, '1');
insert into gun values (2, 'A3', 'Baretta M12', 1, '2');
insert into gun values (3, 'A4', 'IP-2', 2, '3');
insert into gun values (4, 'A5', 'AA-52', 2, '3');
insert into gun values (5, 'A6', 'M48 Patton', 3, '5');
insert into gun values (6, 'B0', 'Heckler & Koch G3', 4, '2');
insert into gun values (7, 'B1', 'Heckler & Koch G3', 4, '2');
insert into gun values (8, 'B2', 'Armalite AR-50', 5, '2');

-- shoot : shooter id, shooter ssn, gun id, field id, platform number, success percentage, date-time
-- truncate table shot;
insert into shot values (1, 0000000001, 7, 6, 1, 50.0, '20160910 14:00');
insert into shot values (1, 0000000001, 0, 0, 3, 70.0, '20161020 11:00');
insert into shot values (0, 0000000006, 7, 6, 2, 55.0, '20160910 14:00');
insert into shot values (0, 0000000005, 5, 3, 1, 100.0, '20160815 08:00');
insert into shot values (2, 0000000002, 3, 4, 5, 75.0, '20160908 11:00');
insert into shot values (4, 0000000004, 8, 5, 2, 85.0, '20160825 13:00');
insert into shot values (0, 0000000007, 8, 5, 1, 87.0, '20160825 13:00');
insert into shot values (3, 0000000003, 4, 6, 2, 40.0, '20160830 18:00');
