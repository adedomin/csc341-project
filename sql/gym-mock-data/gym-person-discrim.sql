-- set all users to customers
UPDATE Team00.Person SET person_type = 'C';

-- random employees
UPDATE Team00.Person 
SET person_type = 'E'
WHERE person_id <= 10;
