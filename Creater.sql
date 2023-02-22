DROP TABLE IF EXISTS invoices CASCADE;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS tariffs;
DROP TABLE IF EXISTS city;
DROP TABLE IF EXISTS reports;

CREATE TABLE reports
(
    id SERIAL PRIMARY KEY,
    month INT,
    year INT,
    number NUMERIC
);

CREATE TABLE tariffs
(
    tid            INT PRIMARY KEY,
    name           TEXT    NOT NULL,
    internet_speed INT,
    is_tv             INT DEFAULT NULL,
    price          NUMERIC NOT NULL,
    CONSTRAINT availability_tv CHECK ( tv = 1 )
);

CREATE TABLE city
(
    cid  INT PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE customers
(
    custid     INT PRIMARY KEY,
    first_name VARCHAR(15)        NOT NULL,
    last_name  VARCHAR(30)        NOT NULL,
    district   INT                not NULL,
    phone      VARCHAR(15) UNIQUE NOT NULL,
    email      TEXT,
    join_time  TIMESTAMP          NOT NULL,
    tariff     INT                NOT NULL,
    CONSTRAINT fk_customer_district
        FOREIGN KEY (district) REFERENCES city (cid) ON DELETE CASCADE,
    CONSTRAINT fk_customer_tariff
        FOREIGN KEY (tariff) REFERENCES tariffs (tid) ON DELETE CASCADE
);

CREATE TABLE invoices
(
    invid   SERIAL PRIMARY KEY,
    custid  INT REFERENCES customers (custid),
    service INT REFERENCES tariffs (tid),
    date    TIMESTAMP NOT NULL,
    price   NUMERIC,
    UNIQUE (custid, date)

);

CREATE VIEW total_per_month AS
    SELECT extract(month FROM date) AS month, SUM(price) AS total
    FROM invoices
    GROUP BY month;