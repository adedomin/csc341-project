INSERT INTO Team00.Person (person_id, first, last, phone, address, city, state, person_type, since, birth) VALUES ();

INSERT INTO Team00.Customer (customer_id, last_payment, is_active) VALUES ();

INSERT INTO Team00.Employee (employee_id, wage, is_trainer) VALUES ();

INSERT INTO Team00.Trainer (trainer_id) VALUES ();

INSERT INTO Team00.Class (trainer_id, class_name, time) VALUES ();

INSERT INTO Team00.Equipment (equip_id, name, brand, equip_type, value, since) VALUES ();

INSERT INTO Team00.WeightEquip (equip_id, weight, weight_type, diameter) VALUES ();

INSERT INTO Team00.MachineEquip (equip_id, machine_type, serial, functioning, last_maintained) VALUES ();

INSERT INTO Team00.Maintenance (equip_id, employee_id, needs_work, work_date) VALUES ();

INSERT INTO Team00.Sessions (customer_id, trainer_id, service_fee, time, days) VALUES ();
