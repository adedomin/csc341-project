INSERT INTO Team00.CustomerFees (fee_id, customer_id)
SELECT f.fee_id, c.customer_id
FROM Team00.Customer c
CROSS JOIN ( SELECT fee_id
    FROM Fees
    WHERE lower(fee_desc) LIKE '%general membership%'
) f;
