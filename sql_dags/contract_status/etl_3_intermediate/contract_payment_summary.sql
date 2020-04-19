-- contract payment summary
INSERT INTO
data_intermediate.contract_payment_summary
SELECT DISTINCT
  tx.contract_id
  , SUM(tx.transaction_amount) OVER(PARTITION by contract_id) AS total_paid
  , COUNT(tx.transaction_id) OVER(PARTITION by contract_id) AS number_payments_made
  , MIN(tx.transaction_date) OVER(PARTITION by contract_id) AS earliest_payment_date
  , MIN(tx.transaction_date) OVER(PARTITION by contract_id) AS latest_payment_date
FROM data_staging.transaction_payment tx
WHERE tx.transaction_amount IS NOT NULL
AND etl_time > '1900-01-01'

ON CONFLICT (contract_id) DO
UPDATE SET
  total_paid              = excluded.total_paid,
  number_payments_made    = excluded.number_payments_made,
  earliest_payment_date   = excluded.earliest_payment_date,
  latest_payment_date     = excluded.latest_payment_date,
  etl_time                = now()
;

