-- contract payment summary
INSERT INTO
data_intermediate.contract_deposit_summary
SELECT DISTINCT
  tx.contract_id
  , SUM(tx.transaction_amount) OVER(PARTITION by contract_id) AS total_deposit_paid
  , COUNT(tx.transaction_id) OVER(PARTITION by contract_id) AS number_deposits_made
  , MIN(tx.transaction_date) OVER(PARTITION by contract_id) AS earliest_deposit_date
  , MIN(tx.transaction_date) OVER(PARTITION by contract_id) AS latest_deposit_date
FROM data_staging.transaction_deposit tx
WHERE tx.transaction_amount IS NOT NULL
AND etl_time > '1900-01-01'

ON CONFLICT (contract_id) DO
UPDATE SET
  total_deposit_paid      = excluded.total_deposit_paid,
  number_deposits_made    = excluded.number_deposits_made,
  earliest_deposit_date   = excluded.earliest_deposit_date,
  latest_deposit_date     = excluded.latest_deposit_date,
  etl_time                = now()
;

