INSERT INTO Team00.Customer (customer_id, last_payment)
SELECT person_id, CURRENT_DATE
FROM Team00.Person
WHERE person_type = 'C';

UPDATE Team00.Customer
SET last_payment = TO_DATE(
    TRUNC(
        DBMS_RANDOM.VALUE(TO_CHAR(DATE '2014-01-01','J')
            ,TO_CHAR(DATE '2016-10-25','J')
        )
    ),'J'
), is_active = 'N' 
WHERE customer_id > 90;
