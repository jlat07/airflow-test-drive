-- finance contract status
INSERT INTO
finance.contract_status
SELECT
  CASE
    WHEN (pd.total_price<=cps.total_paid+cds.total_deposit_paid)
    THEN 'COMPLETED'
    ELSE 'ACTIVE'
  END AS contract_status
  , ct.contract_id
  , customer.first_name ||' '||customer.last_name AS customer_name
  , pd.product_name
  , csd.as_of AS date_of_sale
  , pd.total_price - cps.total_paid - cds.total_deposit_paid AS total_outstanding_balance
  , cpj.projected_paid_amount AS outstanding_balance_to_date
  , cpj.projected_completion_date
  , now() AS etl_time
FROM data_staging.contract AS ct
  LEFT JOIN data_staging.product AS pd
    ON pd.product_id = ct.product_id
  LEFT JOIN data_staging.customer AS customer
    ON customer.customer_id = ct.customer_id
  LEFT JOIN data_intermediate.contract_start_date AS csd
    ON csd.contract_id = ct.contract_id
  LEFT JOIN data_intermediate.contract_projection AS cpj
    ON cpj.contract_id = ct.contract_id
  LEFT JOIN data_intermediate.contract_payment_summary AS cps
    ON cps.contract_id = ct.contract_id
  LEFT JOIN data_intermediate.contract_deposit_summary AS cds
    ON cds.contract_id = ct.contract_id

ON CONFLICT (contract_id) DO
UPDATE SET
  contract_status              = excluded.contract_status,
  customer_name                = excluded.customer_name,
  product_type                 = excluded.product_type,
  date_of_sale                 = excluded.date_of_sale,
  total_outstanding_balance    = excluded.total_outstanding_balance,
  outstanding_balance_to_date  = excluded.outstanding_balance_to_date,
  projected_completion_date    = excluded.projected_completion_date,
  etl_time                     = now()
;


-- SELECT * FROM finance.contract_status
-- WHERE total_outstanding_balance > :v1
--;
