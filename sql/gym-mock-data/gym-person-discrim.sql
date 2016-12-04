-- set all users to customers
UPDATE Person SET person_type = "C";

-- random employees
UPDATE Person 
SET person_type = "E"
WHERE rand() <= 0.10;
