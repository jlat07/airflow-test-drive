-- load to staging_contract
INSERT INTO
data_staging.contract
SELECT
    contract_id::INT
    , customer_id::INT
    , product_id::INT
    , created_at::TIMESTAMPTZ
    , etl_time::TIMESTAMPTZ
FROM data_raw.contract
WHERE etl_time::TIMESTAMPTZ > '1900-01-01'
ON CONFLICT (contract_id) DO
UPDATE SET
  customer_id  = excluded.customer_id,
  product_id   = excluded.product_id,
  created_at   = excluded.created_at,
  etl_time     = excluded.etl_time
;
