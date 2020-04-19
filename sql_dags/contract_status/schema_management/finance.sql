-- staging data schema
DROP schema IF EXISTS finance cascade;
CREATE schema IF NOT EXISTS finance;

-- report contract_status
CREATE TABLE IF NOT EXISTS
finance.contract_status(
  contract_status char(15) NOT NULL,
  contract_id INT NOT NULL,
  customer_name char(75) NOT NULL,
  product_type char(25) NOT NULL,
  date_of_sale TIMESTAMPTZ NOT NULL,
  total_outstanding_balance decimal(10,2) NOT NULL,
  outstanding_balance_to_date decimal(10,2) NOT NULL,
  projected_completion_date TIMESTAMPTZ NOT NULL,
  etl_time TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (contract_id)
);
-- table info
SELECT ordinal_position, column_name, data_type, table_name, table_schema FROM information_schema.columns
WHERE table_schema = 'finance' AND table_name = 'contract_status' ORDER BY ordinal_position ASC
;

