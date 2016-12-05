CREATE TABLE Team00.Person (
    person_id       NUMERIC(10,0)   GENERATED BY DEFAULT ON NULL AS IDENTITY,
    first_name      VARCHAR(30)     NOT NULL,
    last_name       VARCHAR(30)     NOT NULL,
    phone           CHAR(18)        NOT NULL,
    address         VARCHAR(69)     NOT NULL,
    city            VARCHAR(69)     NOT NULL,
    state           CHAR(2)         DEFAULT 'CT',
    person_type     CHAR(1),
    member_since    DATE,
    birth_date      DATE
) TABLESPACE CSC341_TEAM_DATA;

CREATE UNIQUE INDEX Team00.Person_pk_IDX ON Team00.Person (
    person_id
) TABLESPACE CSC341_TEAM_DATA;

CREATE INDEX Team00.Person_determiner_IDX ON Team00.Person (
    person_type
) TABLESPACE CSC341_TEAM_DATA;

ALTER TABLE Team00.Person ADD (
    CONSTRAINT person_pk
        PRIMARY KEY (person_id),
    CONSTRAINT person_type_chk
        CHECK (person_type = 'E' OR person_type = 'C')
);

CREATE TABLE Team00.Customer (
    customer_id     NUMERIC(10,0) NOT NULL,
    last_payment    DATE,
    is_active       CHAR(1)       DEFAULT 'Y'
) TABLESPACE CSC341_TEAM_DATA;

CREATE UNIQUE INDEX Team00.Customer_pk_IDX ON Team00.Customer (
    customer_id
) TABLESPACE CSC341_TEAM_DATA;

-- made based on question 1 (sql-questions.sql)
CREATE INDEX Team00.Customer_active_IDX ON Team00.Customer (
    is_active
) TABLESPACE CSC341_TEAM_DATA;


ALTER TABLE Team00.Customer ADD (
    CONSTRAINT customer_person_fk
        FOREIGN KEY (customer_id) REFERENCES Person (person_id)
            ON DELETE CASCADE,
    CONSTRAINT customer_pk
        PRIMARY KEY (customer_id),
    CONSTRAINT customer_is_active_chk
        CHECK (is_active = 'Y' OR is_active = 'N')
);

CREATE TABLE Team00.Employee (
    employee_id     NUMERIC(10,0)   NOT NULL,
    wage            NUMERIC(5,2)    NOT NULL,
    is_trainer      CHAR(1)         DEFAULT 'N'
) TABLESPACE CSC341_TEAM_DATA;

CREATE UNIQUE INDEX Team00.Employee_pk_IDX ON Team00.Employee (
    employee_id
) TABLESPACE CSC341_TEAM_DATA;

ALTER TABLE Team00.Employee ADD (
    CONSTRAINT person_employee_fk
        FOREIGN KEY (employee_id) REFERENCES Team00.Person (person_id)
            ON DELETE CASCADE,
    CONSTRAINT employee_pk
        PRIMARY KEY (employee_id),
    CONSTRAINT employee_is_trainer_chk
        CHECK (is_trainer = 'N' OR is_trainer = 'Y')
);

CREATE TABLE Team00.Trainer (
    trainer_id      NUMERIC(10,0)
) TABLESPACE CSC341_TEAM_DATA;

CREATE UNIQUE INDEX Team00.Trainer_pk_IDX ON Team00.Trainer (
    trainer_id
) TABLESPACE CSC341_TEAM_DATA;

ALTER TABLE Team00.Trainer ADD (
    CONSTRAINT person_trainer_fk
        FOREIGN KEY (trainer_id) REFERENCES Team00.Employee (employee_id)
            ON DELETE CASCADE,
    CONSTRAINT trainer_pk
        PRIMARY KEY (trainer_id)
);

CREATE TABLE Team00.Class (
    trainer_id      NUMERIC(10,0)       NOT NULL,
    class_name      VARCHAR(30)         NOT NULL,
    time            NUMERIC(4,0),
    days            VARCHAR(7)
) TABLESPACE CSC341_TEAM_DATA;

CREATE UNIQUE INDEX Team00.Class_pk_IDX ON Team00.Class (
    class_name
) TABLESPACE CSC341_TEAM_DATA;

ALTER TABLE Team00.Class ADD (
    CONSTRAINT class_trainer_fk
        FOREIGN KEY (trainer_id) REFERENCES Team00.Trainer (trainer_id)
            ON DELETE SET NULL,
    CONSTRAINT class_pk
        PRIMARY KEY (class_name),
    CONSTRAINT class_time_chk
        CHECK (time > 0 AND time < 2400)
);

CREATE TABLE Team00.Equipment (
    equip_id    NUMERIC(10,0)    GENERATED BY DEFAULT ON NULL AS IDENTITY,
    name         VARCHAR(30)     NOT NULL,
    brand        VARCHAR(30),
    equip_type   CHAR(1)         DEFAULT 'W',
    value        NUMERIC(7,2),
    purchased_at DATE
) TABLESPACE CSC341_TEAM_DATA;

CREATE UNIQUE INDEX Team00.Equip_pk_IDX ON Team00.Equipment (
    equip_id
) TABLESPACE CSC341_TEAM_DATA;

CREATE INDEX Team00.Equip_determiner_IDX ON Team00.Equipment (
    equip_type
) TABLESPACE CSC341_TEAM_DATA;

ALTER TABLE Team00.Equipment ADD (
    CONSTRAINT equipment_pk
        PRIMARY KEY (equip_id),
    CONSTRAINT equipment_type_chk
        CHECK (equip_type = 'M' OR equip_type = 'W')
);

CREATE TABLE Team00.WeightEquip (
    equip_id    NUMERIC(10,0)  NOT NULL,
    weight      NUMERIC(3,0)   NOT NULL,
    weight_type VARCHAR(20)    NOT NULL,
    diameter    NUMERIC(2)
) TABLESPACE CSC341_TEAM_DATA;

CREATE UNIQUE INDEX Team00.WeightEquip_pk_IDX ON Team00.WeightEquip (
    equip_id
) TABLESPACE CSC341_TEAM_DATA;

-- made based on question 8 in gym-questions.sql
CREATE INDEX Team00.WeightEquip_type_IDX ON Team00.WeightEquip (
        weight_type
) TABLESPACE CSC341_TEAM_DATA;

ALTER TABLE Team00.WeightEquip ADD (
    CONSTRAINT weight_equip_fk
        FOREIGN KEY (equip_id) REFERENCES Team00.Equipment (equip_id)
            ON DELETE CASCADE,
    CONSTRAINT weight_pk
        PRIMARY KEY (equip_id)
);

CREATE TABLE Team00.MachineEquip (
    equip_id        NUMERIC(10,0),
    machine_type    VARCHAR(20)     NOT NULL,
    serial          VARCHAR(30)     NOT NULL,
    in_order        CHAR(1)         DEFAULT 'Y',
    last_maintained DATE
) TABLESPACE CSC341_TEAM_DATA;

CREATE UNIQUE INDEX Team00.MachineEquip_pk_IDX ON Team00.MachineEquip (
    equip_id
) TABLESPACE CSC341_TEAM_DATA;

ALTER TABLE Team00.MachineEquip ADD (
    CONSTRAINT machine_fk
        FOREIGN KEY (equip_id) REFERENCES Team00.Equipment (equip_id)
            ON DELETE CASCADE,
    CONSTRAINT machine_pk
        PRIMARY KEY (equip_id),
    CONSTRAINT machine_functioning_chk
        CHECK (in_order = 'N' OR in_order = 'Y')
);

CREATE TABLE Team00.Maintenance (
    equip_id    NUMERIC(10,0)   NOT NULL,
    employee_id NUMERIC(10,0)   NOT NULL,
    needs_work  VARCHAR(50)     NOT NULL,
    work_date   DATE
) TABLESPACE CSC341_TEAM_DATA;

CREATE UNIQUE INDEX Team00.Maintenance_pk_IDX ON Team00.Maintenance (
    equip_id,
    employee_id
) TABLESPACE CSC341_TEAM_DATA;

ALTER TABLE Team00.Maintenance ADD (
    CONSTRAINT maintenance_machine_fk
        FOREIGN KEY (equip_id) REFERENCES Team00.MachineEquip (equip_id)
            ON DELETE CASCADE,
    CONSTRAINT maintenance_employee_fk
        FOREIGN KEY (employee_id) REFERENCES Team00.Employee (employee_id)
            ON DELETE SET NULL,
    CONSTRAINT maintenance_pk
        PRIMARY KEY (equip_id, employee_id)
);

CREATE TABLE Team00.Fees (
    fee_id       NUMERIC(10,0)   GENERATED BY DEFAULT ON NULL AS IDENTITY,
    fee_amount     NUMERIC(5,2)    NOT NULL,
    fee_desc      VARCHAR(50)      NOT NULL
) TABLESPACE CSC341_TEAM_DATA;

CREATE UNIQUE INDEX Team00.Fees_pk_IDX ON Team00.Fees (
    fee_id
) TABLESPACE CSC341_TEAM_DATA;

ALTER TABLE Team00.Fees ADD (
    CONSTRAINT fees_pk
        PRIMARY KEY (fee_id)
);

CREATE TABLE Team00.CustomerFees (
    fee_id      NUMERIC(10)     NOT NULL,
    customer_id NUMERIC(10)     NOT NULL
) TABLESPACE CSC341_TEAM_DATA;

CREATE UNIQUE INDEX Team00.Customer_Fees_pk_IDX ON Team00.CustomerFees (
    fee_id,
    customer_id
) TABLESPACE CSC341_TEAM_DATA;

ALTER TABLE Team00.CustomerFees ADD (
    CONSTRAINT customer_fees_pk
        PRIMARY KEY (fee_id, customer_id),
    CONSTRAINT customer_fees_fees_fk
        FOREIGN KEY (fee_id) REFERENCES Team00.Fees (fee_id)
            ON DELETE SET NULL,
    CONSTRAINT customer_fees_fees_fk
        FOREIGN KEY (customer_id) REFERENCES Team00.Customer (customer_id)
            ON DELETE CASCADE
)

CREATE TABLE Team00.Sessions (
    customer_id     NUMERIC(10,0)   NOT NULL,
    trainer_id      NUMERIC(10,0)   NOT NULL,
    fee_id          NUMERIC(10,0)   NOT NULL,
    time            NUMERIC(4,0),
    days            VARCHAR(7)
) TABLESPACE CSC341_TEAM_DATA;

CREATE UNIQUE INDEX Team00.Sessions_pk_IDX ON Team00.Sessions (
    customer_id,
    trainer_id
) TABLESPACE CSC341_TEAM_DATA;

ALTER TABLE Team00.Sessions ADD (
    CONSTRAINT sessions_customer_fk
        FOREIGN KEY (customer_id) REFERENCES Team00.Customer (customer_id)
            ON DELETE CASCADE,
    CONSTRAINT sessions_fees_fk
        FOREIGN KEY (fee_id) REFERENCES Team00.Fees (fee_id)
            ON DELETE SET NULL,
    CONSTRAINT sessions_trainer_fk
        FOREIGN KEY (trainer_id) REFERENCES Team00.Trainer (trainer_id)
            ON DELETE CASCADE,
    CONSTRAINT sessions_pk
        PRIMARY KEY (customer_id, trainer_id),
    CONSTRAINT sessions_time_chk
        CHECK (time > 0 AND time < 2400)
);
