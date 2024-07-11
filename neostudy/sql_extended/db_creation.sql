-- CREATE DATABASE neoflex;
-- drop table os;
-- drop table model;
-- drop table brand;

CREATE TABLE IF NOT EXISTS brand
(
    id integer PRIMARY KEY, 
    name varchar(128) NOT NULL
);

CREATE TABLE IF NOT EXISTS os
(
    id integer PRIMARY KEY, 
    name varchar(64) NOT NULL
);

CREATE TABLE IF NOT EXISTS model 
(
    id integer PRIMARY KEY, 
    name varchar(128) NOT NULL, 
    brand integer,
    os integer
);


INSERT INTO brand 
VALUES
(1, 'Samsung'),
(2, 'Nokia'),
(3, 'Apple'),
(4, 'Phillips'),
(5, 'Xiaomi'),
(6, 'realme'),
(7, 'Motorola'),
(8, 'HUAWEI'),
(9, 'Palm');


INSERT INTO os 
VALUES
(1, 'Android OS'),
(2, 'Bada'),
(3, 'BlackBerry OS'),
(4, 'iPhone OS / iOS'),
(5, 'MeeGO OS'),
(6, 'Palm OS'),
(7, 'Symbian OS'),
(8, 'webOS'),
(9, 'Windows Mobile');


INSERT INTO model
VALUES
(1, 'N73', 2, 7),
(2, 'Galaxy Note 2', 1, 1),
(3, 'iPhone 5', 3, 4),
(4, 'Lumia 520', 2, 9),
(5, 'N900', 2, 5),
(6, 'Pre', 9, 6);