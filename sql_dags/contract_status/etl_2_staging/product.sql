-- load to staging_product
INSERT INTO
data_staging.product
SELECT
    product_id::INT
    , product_name
    , deposit::decimal(10,2)
    , total_price::decimal(10,2)
    , payment_frequency
    , payment_amount::decimal(10,2)
    , etl_time::TIMESTAMPTZ
FROM data_raw.product
WHERE etl_time > '1900-01-01'

ON CONFLICT (product_id) DO
UPDATE SET
  product_name        = excluded.product_name,
  deposit             = excluded.deposit,
  total_price         = excluded.total_price,
  payment_frequency   = excluded.payment_frequency,
  payment_amount      = excluded.payment_amount,
  etl_time            = excluded.etl_time
;
