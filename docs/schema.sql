create schema [IF not exists] database;

use database;

create TABLE [if not exists] users(
  user_id INT NOT NULL primary key,
  password varchar(250) NOT NULL,
  status enum('CREATED', 'ACTIVE', 'INACTIVE') NOT NULL default 'CREATED',
  first_name varchar(250),
  last_name varchar(250),
  address varchar (250),
  birth_date timestamp,
  licence_obtained_date timestamp,
  licence_expiration_date timestamp,
  id_card_path varchar(250),
  licence_card_path varchar(250)
);

create table [if not exists] categories (
  category_id INT NOT NULL primary key,
  type varchar(1),
  transmission_drive varchar(1),
  fuel_air_cond varchar(1)
);

create table [if not exists] agencies (
  agency_id INT NOT NULL primary key,
  address varchar(250),
  city varchar(250)
);

create table [if not exists] vehicles(
  vehicle_id INT NOT NULL primary key,
  category_id INT NOT NULL,
  booking_id INT NOT NULL,
  agency_id INT NOT NULL,
  acquisition_date timestamp NOT NULL,
  miles BIGINT,
  CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES categories(category_id),
  CONSTRAINT fk_agency FOREIGN KEY (agency_id) REFERENCES agencies(agency_id)
)


create table [if not exists] bookings (
  booking_id INT NOT NULL,
  user_id INT NOT NULL,
  agency_id INT NOT NULL,
  vehicle_id INT NOT NULL,
  booking_start_date timestamp NOT NULL,
  booking_end_date timestamp NOT NULL,
  price FLOAT NOT NULL,
  CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(user_id),
  CONSTRAINT fk_agency FOREIGN KEY (agency_id) REFERENCES agencies(agency_id),
  CONSTRAINT fk_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id)
)

ALTER TABLE vehicles ADD CONSTRAINT fk_booking FOREIGN KEY (booking_id) REFERENCES bookings(booking_id);



