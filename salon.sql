DROP DATABASE salon;
CREATE DATABASE salon WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C.UTF-8' LC_CTYPE = 'C.UTF-8';
ALTER DATABASE salon OWNER TO freecodecamp;

\connect salon

create table customers();
create table appointments();
create table services();

alter table customers add column customer_id serial primary key,
add column phone varchar(20) UNIQUE,
add column name varchar;

alter table appointments add column appointment_id serial primary key,
add column customer_id int,
add column service_id int,
add column time varchar;

alter table services add column service_id serial primary key,
add column name varchar;

alter table appointments add foreign key(customer_id) REFERENCES customers(customer_id);
alter table appointments add foreign key(service_id) REFERENCES services(service_id);


