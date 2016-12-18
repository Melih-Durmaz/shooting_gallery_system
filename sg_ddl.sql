--drop table shooter;
create table shooter (
ssn numeric(10) primary key,
member boolean default false,
birth_date date not null,
name_surname varchar(50) not null,
communication_info varchar(100) not null,
shot_success float default 0,
shot_count int default 0
);

--drop table field;
create table field (
id serial primary key,
lctn varchar(100) not null,
nm varchar(20) not null,
max_range float not null,
throng float default 0
);

--drop table schedule
create table schedule (
field_id int,
start timestamp without time zone not null,
stop timestamp without time zone not null,
foreign key (field_id) references field(id)
    on delete set null
);

--drop table gun_type;
create table gun_type(
id serial primary key,
nm varchar(20) not null,
ammo_percentage float default 50.0
);

--drop table uses_field;
create table uses_field(
gun_type_id int,
field_id int,
foreign key (gun_type_id) references gun_type(id)
    on delete set null,
foreign key (field_id) references field(id)
    on delete set null
);


--drop table gun;
create table gun (
id serial primary key,
serial_number varchar(10) not null unique,
nm varchar(20) not null,
gun_type_id int default 0,
foreign key (gun_type_id) references gun_type 
    on delete set default
);


--drop table shot;
create table shot (
shooter_ssn numeric(10),
gun_id int not null,
field_id int not null,
success_percentage float not null,
start_date timestamp without time zone not null,
stop_date timestamp without time zone not null,
foreign key (shooter_ssn) references shooter
    on delete set null,
foreign key (gun_id) references gun,
foreign key (field_id) references field
);
