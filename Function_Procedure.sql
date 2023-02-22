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
    SELECT custid, tariff, current_timestamp, price
        FROM customers
        INNER JOIN tariffs t ON customers.tariff = t.tid
        WHERE custid = id;
END;
$$ LANGUAGE plpgsql;


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

CREATE OR REPLACE PROCEDURE count_connect(month_r INT, year_r INT) LANGUAGE plpgsql AS
    $$
    BEGIN
        BEGIN
        INSERT INTO reports(month, year, number)
        SELECT month_r, year_r, COUNT(1)
        FROM invoices
        WHERE EXTRACT(MONTH FROM date) = month_r AND
              EXTRACT(YEAR FROM date) = year_r AND
              service = 6;
        END;
        COMMIT;
    END;
    $$;
