-- staging data schema
DROP schema IF EXISTS data_staging cascade;
CREATE schema data_staging;


-- staging customer
CREATE TABLE IF NOT EXISTS
data_staging.customer(
  customer_id INT NOT NULL,
  first_name char(25) NOT NULL,
  last_name char(25) NOT NULL,
  etl_time TIMESTAMPTZ NOT NULL,
  PRIMARY KEY (customer_id)
);
-- table info
SELECT ordinal_position, column_name, data_type, table_name, table_schema FROM information_schema.columns
WHERE table_schema = 'data_staging' AND table_name = 'customer' ORDER BY ordinal_position ASC
;


-- staging contract
CREATE TABLE IF NOT EXISTS
data_staging.contract(
  contract_id INT NOT NULL,
  customer_id INT NOT NULL,
  product_id INT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  etl_time TIMESTAMPTZ NOT NULL,
  PRIMARY KEY (contract_id)
);
-- table info
SELECT ordinal_position, column_name, data_type, table_name, table_schema FROM information_schema.columns
WHERE table_schema = 'data_staging' AND table_name = 'contract' ORDER BY ordinal_position ASC
;


-- staging product
CREATE TABLE IF NOT EXISTS
data_staging.product(
  product_id INT NOT NULL,
  product_name char(25) NOT NULL,
  deposit decimal(10,2) NOT NULL,
  total_price decimal(10,2) NOT NULL,
  payment_frequency char(25) NOT NULL,
  payment_amount decimal(10,2),
  etl_time TIMESTAMPTZ NOT NULL,
  PRIMARY KEY (product_id)
);
-- table info
SELECT ordinal_position, column_name, data_type, table_name, table_schema FROM information_schema.columns
WHERE table_schema = 'data_staging' AND table_name = 'product' ORDER BY ordinal_position ASC
;


-- staging transaction payment
CREATE TABLE IF NOT EXISTS
data_staging.transaction_payment(
  transaction_id INT NOT NULL,
  contract_id INT NOT NULL,
  transaction_status char(25),
  transaction_amount decimal(10,2),
  transaction_date TIMESTAMPTZ NOT NULL,
  etl_time TIMESTAMPTZ NOT NULL,
  PRIMARY KEY (transaction_id)
);
-- table info
SELECT ordinal_position, column_name, data_type, table_name, table_schema FROM information_schema.columns
WHERE table_schema = 'data_staging' AND table_name = 'transaction_payment' ORDER BY ordinal_position ASC
;


-- staging transaction payment
CREATE TABLE IF NOT EXISTS
data_staging.transaction_deposit(
  transaction_id INT NOT NULL,
  contract_id INT NOT NULL,
  transaction_status char(25),
  transaction_amount decimal(10,2),
  transaction_date TIMESTAMPTZ NOT NULL,
  etl_time TIMESTAMPTZ NOT NULL,
  PRIMARY KEY (transaction_id)
);
-- table info
SELECT ordinal_position, column_name, data_type, table_name, table_schema FROM information_schema.columns
WHERE table_schema = 'data_staging' AND table_name = 'transaction_deposit' ORDER BY ordinal_position ASC
;





