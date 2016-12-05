-- TERM SET UP
SET LINESIZE 1000
SET PAGESIZE 1000
SET TRIMSPOOL ON
SET FEEDBACK off

-- 1) The sales and retention team want to know all the phone numbers and names of inactive users
SELECT p.first_name, p.last_name, p.phone
FROM Team00.Person p 
INNER JOIN Team00.Customer c
    ON c.customer_id = p.person_id
WHERE c.is_active = 'N';

-- FIRST_NAME             LAST_NAME              PHONE
-- ---------------------- ---------------------- ------------------
-- Henry                  Willis                 53-(924)547-5501
-- Elizabeth              Freeman                62-(147)643-2666
-- Timothy                Hayes                  54-(303)347-6971
-- Debra                  Webb                   226-(755)159-6069
-- Heather                Young                  46-(988)814-1688
-- Daniel                 Hill                   54-(567)660-1343
-- Phillip                Schmidt                93-(915)940-0054
-- Frank                  Lewis                  46-(235)489-5841
-- Randy                  Fowler                 48-(432)271-9002
-- Carol                  Hunt                   86-(205)256-4413


-- 2) How many machines are available for spin class (cycle machines)?
SELECT count(*) AS total_cycle_machines
FROM Team00.MachineEquip
WHERE machine_type LIKE '%cycle%';

-- TOTAL_CYCLE_MACHINES
-- --------------------
--                   10

--- 3) Check to see if a classes conflicts with a personal trainer sessions

SELECT c.class_name, s.trainer_id, s.customer_id, c.time
FROM Team00.Sessions s
INNER JOIN Team00.Class c
    ON c.trainer_id = s.trainer_id
WHERE c.time = s.time AND c.days = s.days;

-- CLASS_NAME                     TRAINER_ID CUSTOMER_ID       TIME
-- ------------------------------ ---------- ----------- ----------
-- squating to the moon                  101          24       1800
-- squating to the moon                  101          27       1800

--- 4) this should show conflicting sessions

SELECT a.customer_id, b.customer_id, a.trainer_id, a.time
FROM Team00.Sessions a
INNER JOIN Team00.Sessions b
    ON a.time = b.time AND a.days = b.days
WHERE a.trainer_id = b.trainer_id
  AND a.customer_id <> b.customer_id;

-- CUSTOMER_ID CUSTOMER_ID TRAINER_ID       TIME
-- ----------- ----------- ---------- ----------
--          27          24        101       1800
--          24          27        101       1800

-- 5) Get total expected monthly amount from each customer, apply birthday discount for people with birthdays this month (dec)

SELECT customer_id, sum(fee_amount) AS TOTAL_DUE
FROM ( SELECT cp.customer_id, f.fee_id
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

-- CUSTOMER_ID  TOTAL_DUE
-- ----------- ----------
--          35         15
--          18         15
--          39         15
--          16         15
--          97         15
--          22         40
--          25         40
--          42         40
--          43         40
--          51         40
--          57         40
--          78         40
--          83         40
--          87         40
--          91         40
--         100         40
--          11         40
--          13         40
--          28         40
--          29         40
--          44         40
--          47         40
--          59         40
--          76         40
--          77         40
--          14         40
--          20         40
--          21         40
--          26         40
--          31         40
--          66         40
--          70         40
--          72         40
--          84         40
--          86         40
--          88         40
--          90         40
--          95         40
--          24         40
--          32         40
--          46         40
--          53         40
--          68         40
--          81         40
--          85         40
--          94         40
--          96         40
--          17         40
--          23         40
--          37         40
--          38         40
--          48         40
--          55         40
--          61         40
--          63         40
--          69         40
--          74         40
--          75         40
--          33         40
--          40         40
--          41         40
--          45         40
--          50         40
--          52         40
--          56         40
--          71         40
--          80         40
--          93         40
--          99         40
--          27         40
--          36         40
--          49         40
--          58         40
--          64         40
--          89         40
--          12         40
--          15         40
--          19         40
--          60         40
--          62         40
--          65         40
--          67         40
--          73         40
--          79         40
--          82         40
--          92         40
--          98         40
--          30        240
--          54        240
--          34        240

-- 6) Use above to derive total expected amount for this month

SELECT sum(TOTAL_DUE) AS monthly_accounts_recv
FROM (
    SELECT customer_id, sum(fee_amount) AS TOTAL_DUE
    FROM ( SELECT cp.customer_id, f.fee_id
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

-- MONTHLY_ACCOUNTS_RECV
-- ---------------------
--                  4075

-- 7) What employees (their names) are expected to maintain what machines. 
--    machine as in id and serial number with what needs work.

SELECT p.first_name, p.last_name, m.equip_id, m.serial, m.needs_work, m.work_date
FROM ( SELECT px.first_name, px.last_name, ex.employee_id
       FROM Team00.Person px
       INNER JOIN Team00.Employee ex
         ON px.person_id = ex.employee_id ) p
INNER JOIN ( SELECT mx.equip_id, mx.serial, mtx.needs_work, mtx.employee_id, mtx.work_date
             FROM Team00.MachineEquip mx
             INNER JOIN Team00.Maintenance mtx
               ON mx.equip_id = mtx.equip_id ) m
ON m.employee_id = p.employee_id
ORDER BY m.work_date;

-- FIRST_NAME                     LAST_NAME                        EQUIP_ID SERIAL                         NEEDS_WORK                                         WORK_DATE
-- ------------------------------ ------------------------------ ---------- ------------------------------ -------------------------------------------------- ---------
-- Scott                          Larson                                  6 4UNGEZL8DZEQH0SRQPO70HW6BBQVLP belt lubrication                                   05-DEC-16
-- Carl                           Morgan                                  4 YOXUH6YTVFW8ISQIB2B7WQYS2NKHX0 resistor in motor                                  06-DEC-16
-- James                          Simpson                                 9 4998AW8FLRGF1VPO8HJTIHIPVY0BCR check screw tightness                              08-DEC-16
-- 
-- 8) Make sure there are at least 10 plates to one weightlifting bar.

SELECT p.plates / b.bars AS plates_to_bars_ratio
FROM ( SELECT count(weight_type) AS plates
       FROM Team00.WeightEquip
       WHERE weight_type = 'plate' ) p,
     ( SELECT count(weight_type) AS bars
       FROM Team00.WeightEquip
       WHERE weight_type = 'bar' ) b;

-- PLATES_TO_BARS_RATIO
-- --------------------
--           3.44444444

-- 9) get address line and names of employees and find their weekly wages. but find one which one costs the most.

SELECT p.first_name, p.last_name, p.address, p.city, p.state, e.wage * 40
FROM Team00.Person p
INNER JOIN ( SELECT employee_id, wage
             FROM Team00.Employee ) e
ON p.person_id = e.employee_id
WHERE e.wage = ( SELECT max(wage) FROM Team00.Employee );

-- FIRST_NAME                     LAST_NAME                      ADDRESS                                                               CITY                                                                  ST  E.WAGE*40
-- ------------------------------ ------------------------------ --------------------------------------------------------------------- --------------------------------------------------------------------- -- ----------
-- John                           Tucker                         49 Veith Pass                                                         Tomsk                                                                 CT 1107.6

-- 10) What classes are taught on mondays wednesdays and fridays between 8 am and 5 pm?

SELECT class_name, time, days
FROM Team00.Class
WHERE ( days LIKE '%m%' 
        OR days LIKE '%w%'
        OR days LIKE '%f%' )
AND time BETWEEN 800 AND 1700;

-- CLASS_NAME                           TIME DAYS
-- ------------------------------ ---------- -------
-- spin class                           1300 wf

-- 11) Make sure session fees are inserted into CustomerFees (just discovered model weakness)?
