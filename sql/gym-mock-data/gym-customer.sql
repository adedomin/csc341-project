INSERT INTO Team00.Customer (customer_id)
    SELECT person_id 
    FROM Team00.Person
    WHERE person_type = "C";

UPDATE Team00.Customer
SET last_payment = TO_DATE(
    TRUNC(
        DBMS_RANDOM.VALUE(
            TO_CHAR(DATE '2014-03-20','J'),
            TO_CHAR(DATE '2015-12-31','J'))
    )
) AND is_active = 'N';
WHERE rand() <= 0.2;
