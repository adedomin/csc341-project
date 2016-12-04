-- set all users to customers
UPDATE Team00.Person SET person_type = 'C';

-- random employees
UPDATE Team00.Person 
SET person_type = 'E'
WHERE dbms_random.value(0.00, 1.00) <= 0.10;
