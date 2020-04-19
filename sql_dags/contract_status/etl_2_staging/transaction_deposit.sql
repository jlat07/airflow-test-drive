-- load to staging_transaction
INSERT INTO
data_staging.transaction_deposit
SELECT
    transaction_id::INT
    , contract_id::INT
    , transaction_status
    , transaction_amount::decimal(10,2)
    , transaction_date::TIMESTAMPTZ
    , etl_time::TIMESTAMPTZ
FROM data_raw.transaction
WHERE transaction_type = 'DEPOSIT'
AND etl_time > '1900-01-01'

ON CONFLICT (transaction_id) DO
UPDATE SET
  contract_id          = excluded.contract_id,
  transaction_status   = excluded.transaction_status,
  transaction_amount   = excluded.transaction_amount,
  transaction_date     = excluded.transaction_date,
  etl_time            = now()
;
