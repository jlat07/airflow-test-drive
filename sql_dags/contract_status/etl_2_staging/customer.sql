-- load to staging_customer
INSERT INTO
data_staging.customer
SELECT
    customer_id::INT
    , first_name
    , last_name
    , etl_time::TIMESTAMPTZ
FROM data_raw.customer
WHERE etl_time::TIMESTAMPTZ > '1900-01-01'

ON CONFLICT (customer_id) DO
UPDATE SET
  first_name   = excluded.first_name,
  last_name    = excluded.last_name,
  etl_time     = excluded.etl_time
;
