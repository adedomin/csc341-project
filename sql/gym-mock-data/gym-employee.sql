INSERT INTO Team00.Employee (employee_id, wage)
    SELECT person_id, trunc(dbms_random.value(13.00, 30.00), 2)
    FROM Team00.Person
    WHERE person_type = 'E';

UPDATE Team00.Employee
SET is_trainer = 'Y'
WHERE employee_id <= 3;
