-- This was extra data added after the fact to allow for more in depth questions

insert into Team00.Person (first_name, last_name, phone, address, city, state, member_since, birth_date, person_type)
values ('Daniel', 'Eastmann', '1-(203)840-7095', '494 Esch Drive', 'Springfield', 'MA', '20-Feb-2016', '23-Jan-1995', 'E');

insert into Team00.Employee (employee_id, is_trainer, wage)
values (101, 'Y', 23.00);

insert into Team00.Trainer (trainer_id)
values (101);

insert into Team00.Sessions (customer_id, trainer_id, fee_id, time, days)
values (24, 101, 2, 1800, 'mf');

insert into Team00.Class (trainer_id, class_name, time, days)
values (101, 'squating to the moon', 1800, 'mf');

insert into Team00.Sessions (customer_id, trainer_id, fee_id, time, days)
values (27, 101, 2, 1800, 'mf');
