INSERT INTO Team00.MachineEquip (equip_id, machine_type, serial, last_maintained)
SELECT equip_id, name, dbms_random.string('X', 30),
TO_DATE(
    TRUNC(
        DBMS_RANDOM.VALUE(TO_CHAR(DATE '2016-07-01','J')
            ,TO_CHAR(DATE '2016-12-31','J')
        )
    ),'J'
)
FROM Team00.Equipment
WHERE equip_type = 'M';
