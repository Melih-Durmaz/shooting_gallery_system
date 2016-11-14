--drop table shooter;
create table shooter (
id int not null,
ssn numeric(10) not null,
birth_date date not null,
name_surname varchar(50) not null,
communication_info varchar(100) not null,
primary key (id, ssn)
);

--drop table field;
create table field (
id int primary key,
lctn varchar(100) not null,
nm varchar(20) not null,
schedule varchar(200) not null,
platform_count int not null,
max_range float not null,
maintenance_info varchar(100) not null
);

--drop table gun_type;
create table gun_type(
id int primary key,
nm varchar(20) not null,
charge float not null,
field_id int not null,
ammo_percentage float not null,
foreign key (field_id) references field
);


--drop table gun;
create table gun (
id int primary key,
serial_number varchar(10) not null,
nm varchar(20) not null,
gun_type_id int not null,
maintenance_info varchar(100) not null,
foreign key (gun_type_id) references gun_type
);


--drop table shot;
create table shot (
shooter_id int not null,
shooter_ssn numeric(10) not null,
gun_id int not null,
field_id int not null,
platform_num int not null,
success_percentage int not null,
date_time timestamp not null,
foreign key (shooter_id, shooter_ssn) references shooter,
foreign key (gun_id) references gun,
foreign key (field_id) references field
);