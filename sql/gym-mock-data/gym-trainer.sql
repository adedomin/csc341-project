INSERT INTO Team00.Trainer (trainer_id)
    SELECT employee_id
    FROM Team00.Employee
    WHERE is_trainer = 'Y';
