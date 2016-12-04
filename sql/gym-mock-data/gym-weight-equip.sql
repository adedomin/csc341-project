INSERT INTO Team00.WeightEquip (equip_id, weight, weight_type)
SELECT equip_id, trunc(dbms_random.value(5,100), 0), 'dumbbell'
FROM Team00.Equipment
WHERE equip_type = 'W'
  AND name LIKE '%dumbbell%';

INSERT INTO Team00.WeightEquip (equip_id, weight, weight_type, diameter)
SELECT equip_id, 44, 'bar', 2
FROM Team00.Equipment
WHERE equip_type = 'W'
  AND name LIKE '%bar%';

INSERT INTO Team00.WeightEquip (equip_id, weight, weight_type, diameter)
SELECT equip_id, trunc(dbms_random.value(5,45), 0), 'plate', 2
FROM Team00.Equipment
WHERE equip_type = 'W'
  AND name LIKE '%plate%';
