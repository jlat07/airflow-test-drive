-- contract start date
INSERT INTO 
data_intermediate.contract_start_date

SELECT
  ct.contract_id
  , coalesce(cds.earliest_deposit_date, cps.earliest_payment_date, ct.created_at) AS as_of
FROM data_staging.contract ct
  LEFT JOIN data_intermediate.contract_deposit_summary cds
    ON cds.contract_id = ct.contract_id
  LEFT JOIN data_intermediate.contract_payment_summary cps
    ON cps.contract_id = ct.contract_id


ON CONFLICT (contract_id) DO
UPDATE SET
  as_of       = excluded.as_of,
  etl_time    = now()
;
