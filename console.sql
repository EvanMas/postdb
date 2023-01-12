DROP TABLE IF EXISTS invoices;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS tariffs;
DROP TABLE IF EXISTS city;


CREATE TABLE tariffs
(
    tid            INT PRIMARY KEY,
    name           TEXT    NOT NULL,
    internet_speed INT,
    tv             INT DEFAULT NULL,
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

DROP FUNCTION IF EXISTS open_payment_to_connection;
CREATE FUNCTION open_payment_to_connection() RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO invoices (custid, service, date, price)
    SELECT nt.custid, 6, nt.join_time, 1500
    FROM new_table nt;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


DROP TRIGGER IF EXISTS payment_to_connection ON customers;
CREATE TRIGGER payment_to_connection AFTER INSERT ON customers
    REFERENCING NEW TABLE AS new_table
    FOR EACH STATEMENT
    EXECUTE PROCEDURE open_payment_to_connection();

DROP FUNCTION IF EXISTS open_tariff_payment;
CREATE FUNCTION open_tariff_payment(id int) RETURNS VOID AS
$$
BEGIN
    INSERT INTO invoices (custid, service, date, price)
    SELECT custid, tariff, join_time, price
        FROM customers
        INNER JOIN tariffs t ON customers.tariff = t.tid
        WHERE custid = id;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS open_tariff_payment_all;
CREATE FUNCTION open_tariff_payment_all() RETURNS VOID AS
$$
BEGIN
    INSERT INTO invoices (custid, service, date, price)
    WITH RECURSIVE sd AS
    (
        SELECT custid, tariff, current_timestamp, price
            FROM customers
            INNER JOIN tariffs t ON customers.tariff = t.tid
            WHERE custid = (SELECT MIN(custid) FROM customers)
        UNION
        SELECT custid, tariff, current_timestamp, price
            FROM customers
            INNER JOIN tariffs t ON customers.tariff = t.tid
    )
    SELECT * FROM sd;
END;
$$ LANGUAGE plpgsql;


INSERT INTO city
VALUES (1, 'North'),
       (2, 'East'),
       (3, 'South'),
       (4, 'West');

INSERT INTO tariffs
VALUES (1, 'Based', 100, NULL, 500),
       (2, 'Faster', 200, NULL, 750),
       (3, 'Based+', 100, 1, 800),
       (4, 'Ultra full top for your money', 200, 1, 950),
       (5, 'Only TV', NULL, 1, 500),
       (6, 'Connection', NULL, NULL, 1500);

INSERT INTO customers(custid, first_name, last_name, district, phone, email, join_time, tariff)
VALUES (1, 'Ivan', 'Ivanov', 1, '9884562122', 'bigivan@mail.com', current_timestamp, 1),
       (2, 'Smith', 'Tracy', 1, '9205555555', NULL, current_timestamp, 1),
       (3, 'Rownam', 'Tim', 2, '9882220101', NULL, current_timestamp, 3),
       (4, 'Joplette', 'Janice', 4, '9209424710', 'jj@mail.com', current_timestamp, 2),
       (5, 'Butters', 'Gerald', 4, '9880784130', 'geralk@mail.com', current_timestamp, 2),
       (6, 'Tracy', 'Burton', 4, '9883549973', NULL, current_timestamp, 1),
       (7, 'Dare', 'Nancy', 1, '9887764001', 'dareands@mail.com', current_timestamp, 1),
       (8, 'Boothe', 'Tim', 4, '9204332547', 'asdfg@mail.com', current_timestamp, 2),
       (9, 'Stibbons', 'Ponder', 3, '9201603900', 'llloe@mail.com', current_timestamp, 4),
       (10, 'Owen', 'Charles', 3, '9885425251', 'Oven@mail.com', current_timestamp, 4),
       (11, 'Jones', 'David', 1, '9885368036', 'David111@mail.com', current_timestamp, 2),
       (12, 'Baker', 'Anne', 1, '9880765141', 'Annaofnumber1@mail.com', current_timestamp, 1),
       (13, 'Farrell', 'Jemima', 2, '9880160163', NULL, current_timestamp, 2),
       (14, 'Smith', 'Jack', 2, '9881633254', 'parrot@mail.com', current_timestamp, 3),
       (15, 'Bader', 'Florence', 3, '9204993527', 'ital@mail.com', current_timestamp, 2),
       (16, 'Baker', 'Timothy', 3, '9209410824', 'timoty@mail.com', current_timestamp, 2),
       (17, 'Pinker', 'David', 2, '9204096734', 'David112@mail.com', current_timestamp, 1),
       (18, 'Genting', 'Matthew', 2, '9889721377', NULL, current_timestamp, 4),
       (19, 'Mackenzie', 'Anna', 4, '9886612898', NULL, current_timestamp, 2),
       (20, 'Coplin', 'Joan', 3, '9204992232', NULL, current_timestamp, 3),
       (21, 'Sarwin', 'Ramnaresh', 4, '9204131470', 'rammstein@mail.com', current_timestamp, 2),
       (22, 'Jones', 'Douglas', 1, '9885367036', 'lol@mail.com', current_timestamp, 1),
       (23, 'Rumney', 'Henrietta', 3, '9209898876', 'lol696@mail.com', current_timestamp, 2),
       (24, 'Farrell', 'David', 2, '9887559876', NULL, current_timestamp, 3),
       (25, 'Worthington', 'Smyth', 1, '9208943758', 'blanc9@mail.com', current_timestamp, 2),
       (26, 'Purview', 'Millicent', 2, '9889419786', 'Foo2107@mail.com', current_timestamp, 3);

CREATE OR REPLACE FUNCTION open_tariff_payment_all() RETURNS VOID AS
$$
BEGIN
    IF extract(day FROM current_timestamp) >= 13 THEN
        INSERT INTO invoices (custid, service, date, price)
        WITH RECURSIVE sd AS
        (
            SELECT custid, tariff, current_timestamp, price
                FROM customers
                INNER JOIN tariffs t ON customers.tariff = t.tid
            WHERE custid = (SELECT MIN(custid) FROM customers)
            UNION
            SELECT custid, tariff, current_timestamp, price
                FROM customers
                INNER JOIN tariffs t ON customers.tariff = t.tid
        )
        SELECT * FROM sd;
    ELSE
        RAISE EXCEPTION 'No earlier than the 13th of the current month';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE VIEW total_per_month AS
    SELECT extract(month FROM date) AS month, SUM(price) AS total
    FROM invoices
    GROUP BY month;

ALTER TABLE city RENAME TO town;









