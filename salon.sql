CREATE DATABASE salon;

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

INSERT INTO services (service_id, name)
VALUES (1, 'cut');
INSERT INTO services (service_id, name)
VALUES (2, 'color');
INSERT INTO services (service_id, name)
VALUES (3, 'perm');
INSERT INTO services (service_id, name)
VALUES (4, 'style');
INSERT INTO services (service_id, name)
VALUES (5, 'trim');
