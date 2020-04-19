-- contract projection
INSERT INTO 
data_intermediate.contract_projection

WITH

contract_prep AS(
  SELECT
    ct.contract_id
    , csd.as_of AS contract_start_date
    , ((pd.total_price-pd.deposit)/pd.payment_amount)::INT AS projected_total_number_payments
    , csd.as_of +
        (((pd.total_price-pd.deposit)/pd.payment_amount)::INT || 'day')::INTERVAL
        AS projected_completion_date
    , LEAST(
        date_part('day', now()-csd.as_of)::INT,
        ((pd.total_price-pd.deposit)/pd.payment_amount)::INT
      ) AS projected_number_payments
    , pd.payment_amount
    , pd.total_price-pd.deposit AS financed_amount
    , pd.total_price
  FROM data_staging.contract ct
    LEFT JOIN data_staging.product pd
      ON pd.product_id = ct.product_id
    LEFT JOIN data_intermediate.contract_start_date csd
      ON csd.contract_id = ct.contract_id
)

SELECT
  ct.contract_id
  , ct.customer_id
  , ct.product_id
  , cp.contract_start_date
  , cp.projected_completion_date
  , cp.projected_total_number_payments
  , cp.projected_number_payments
  , least(cp.financed_amount, cp.payment_amount*cp.projected_number_payments) AS projected_paid_amount
  , greatest(0, cp.financed_amount - (cp.payment_amount*projected_number_payments)) AS projected_outstanding_balance
  , now() AS projection_date
FROM data_staging.contract ct
  LEFT JOIN contract_prep cp
    ON cp.contract_id = ct.contract_id

ON CONFLICT (contract_id) DO
UPDATE SET
  customer_id                      = excluded.customer_id,
  product_id                       = excluded.product_id,
  contract_start_date              = excluded.contract_start_date,
  projected_completion_date        = excluded.projected_completion_date,
  projected_total_number_payments  = excluded.projected_total_number_payments,
  projected_number_payments        = excluded.projected_number_payments,
  projected_paid_amount            = excluded.projected_paid_amount,
  projected_outstanding_balance    = excluded.projected_outstanding_balance,
  projection_date                  = excluded.projection_date,
  etl_time                         = now()
;

