-- 1) The sales and retention team want to know all the phone numbers and names of inactive users
SELECT p.first_name, p.last_name, p.phone
FROM Team00.Person p 
INNER JOIN Team00.Customer c
    ON c.customer_id = p.person_id
WHERE c.is_active = 'N';

-- 2) How many machines are available for spin class (cycle machines)?
SELECT count(*)
FROM Team00.MachineEquip
WHERE machine_type LIKE '%cycle%';

--- 3) Check to see if a classes conflicts with a personal trainer sessions
-- should be null, as in no rows

SELECT c.class_name, s.trainer_id, s.customer_id, c.time
FROM Team00.Sessions s
INNER JOIN Team00.Class c
    ON c.trainer_id = s.trainer_id
WHERE c.time = s.time;

--- 4) this should show conflicting sessions

SELECT a.customer_id, b.customer_id, a.trainer_id, a.time
FROM Team00.Sessions a
INNER JOIN Team00.Sessions b
    ON a.time = b.time
WHERE a.trainer_id = b.trainer_id
  AND a.customer_id <> b.customer_id;

-- 5) Get total expected monthly amount from each customer, apply birthday discount for people with birthdays this month (dec)

SELECT customer_id, sum(fee_amount) AS TOTAL_DUE
FROM (
    SELECT cp.customer_id, f.fee_id
    FROM ( SELECT c.customer_id, p.birth_date
           FROM Team00.Customer c
           INNER JOIN Team00.Person p
               ON p.person_id = c.customer_id ) cp
          CROSS JOIN ( SELECT fee_id 
                       FROM Team00.Fees
                       WHERE lower(fee_desc) LIKE '%birthday%') f
      WHERE to_char(CURRENT_DATE, 'MONTH') = to_char(cp.birth_date, 'MONTH')
    UNION ALL
    SELECT customer_id, fee_id FROM Team00.CustomerFees) u
INNER JOIN Team00.Fees f
    ON f.fee_id = u.fee_id
GROUP BY customer_id
ORDER BY TOTAL_DUE;

-- 6) Use above to derive total expected amount for this month

SELECT sum(TOTAL_DUE)
FROM (
    SELECT customer_id, sum(fee_amount) AS TOTAL_DUE
    FROM (
        SELECT cp.customer_id, f.fee_id
        FROM ( SELECT c.customer_id, p.birth_date
               FROM Team00.Customer c
               INNER JOIN Team00.Person p
                   ON p.person_id = c.customer_id ) cp
              CROSS JOIN ( SELECT fee_id 
                           FROM Team00.Fees
                           WHERE lower(fee_desc) LIKE '%birthday%') f
          WHERE to_char(CURRENT_DATE, 'MONTH') = to_char(cp.birth_date, 'MONTH')
        UNION ALL
        SELECT customer_id, fee_id FROM Team00.CustomerFees) u
    INNER JOIN Team00.Fees f
        ON f.fee_id = u.fee_id
    GROUP BY customer_id
    ORDER BY TOTAL_DUE);
