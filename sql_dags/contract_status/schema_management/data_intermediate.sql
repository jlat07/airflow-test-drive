-- schema
DROP schema IF EXISTS data_intermediate cascade;
CREATE schema data_intermediate;


-- contract start date
CREATE TABLE IF NOT EXISTS
data_intermediate.contract_start_date(
  contract_id INT NOT NULL,
  as_of TIMESTAMPTZ NOT NULL,
  etl_time TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (contract_id)
);
-- table info
SELECT ordinal_position, column_name, data_type, table_name, table_schema FROM information_schema.columns
WHERE table_schema = 'data_intermediate' AND table_name = 'contract_start_date' ORDER BY ordinal_position ASC
;


-- customer payment summary
CREATE TABLE IF NOT EXISTS
data_intermediate.contract_payment_summary(
  contract_id INT NOT NULL,
  total_paid decimal(10,2) NOT NULL,
  number_payments_made INT,
  earliest_payment_date TIMESTAMPTZ,
  latest_payment_date TIMESTAMPTZ,
  etl_time char(50) DEFAULT NOW(),
  PRIMARY KEY (contract_id)
);
-- table info
SELECT ordinal_position, column_name, data_type, table_name, table_schema FROM information_schema.columns
WHERE table_schema = 'data_intermediate' AND table_name = 'contract_payment_summary' ORDER BY ordinal_position ASC
;


-- customer deposit summary
CREATE TABLE IF NOT EXISTS
data_intermediate.contract_deposit_summary(
  contract_id INT NOT NULL,
  total_deposit_paid decimal(10,2) NOT NULL,
  number_deposits_made INT,
  earliest_deposit_date TIMESTAMPTZ,
  latest_deposit_date TIMESTAMPTZ,
  etl_time char(50) DEFAULT NOW(),
  PRIMARY KEY (contract_id)
);
-- table info
SELECT ordinal_position, column_name, data_type, table_name, table_schema FROM information_schema.columns
WHERE table_schema = 'data_intermediate' AND table_name = 'contract_payment_summary' ORDER BY ordinal_position ASC
;


-- contract projection
CREATE TABLE IF NOT EXISTS
data_intermediate.contract_projection(
  contract_id INT NOT NULL,
  customer_id INT NOT NULL,
  product_id INT NOT NULL,
  contract_start_date TIMESTAMPTZ NOT NULL,
  projected_completion_date TIMESTAMPTZ,
  projected_total_number_payments INT NOT NULL,
  projected_number_payments INT NOT NULL,
  projected_paid_amount decimal(10,2),  -- projected balance as of projection date
  projected_outstanding_balance decimal(10,2),  -- projected balance as of projection date
  projection_date TIMESTAMPTZ DEFAULT NOW(),
  etl_time TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (contract_id)
);
-- table info
SELECT ordinal_position, column_name, data_type, table_name, table_schema FROM information_schema.columns
WHERE table_schema = 'data_intermediate' AND table_name = 'contract_projection' ORDER BY ordinal_position ASC
;

