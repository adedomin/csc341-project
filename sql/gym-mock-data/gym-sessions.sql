INSERT INTO Team00.Sessions (customer_id, trainer_id, fee_id, time, days)
VALUES (34, 1, 2, 1000, 'mwf');

INSERT INTO Team00.Sessions (customer_id, trainer_id, fee_id, time, days)
VALUES (30, 3, 2, 1500, 'rf');

INSERT INTO Team00.Sessions (customer_id, trainer_id, fee_id, time, days)
VALUES (54, 2, 2, 1300, 'tr');

INSERT INTO Team00.CustomerFees (fee_id, customer_id)
VALUES (2, 54);

INSERT INTO Team00.CustomerFees (fee_id, customer_id)
VALUES (2, 34);

INSERT INTO Team00.CustomerFees (fee_id, customer_id)
VALUES (2, 30);
