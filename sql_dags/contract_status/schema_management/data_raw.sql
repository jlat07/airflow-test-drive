-- raw data schema
DROP schema IF EXISTS data_raw cascade;
CREATE schema IF NOT EXISTS data_raw;


-- raw customer
CREATE TABLE IF NOT EXISTS
data_raw.customer(
  customer_id char(25),
  first_name char(25),
  last_name char(25),
  etl_time char(50) DEFAULT (NOW() AT TIME zone 'utc'),
  PRIMARY KEY (customer_id)
);
-- table info
SELECT ordinal_position, column_name, data_type, table_name, table_schema FROM information_schema.columns
WHERE table_schema = 'data_raw' AND table_name = 'customer' ORDER BY ordinal_position ASC
;


-- raw contract
CREATE TABLE IF NOT EXISTS
data_raw.contract(
  contract_id char(25),
  customer_id char(25),
  product_id char(25),
  created_at char(100),
  etl_time char(50) DEFAULT (NOW() AT TIME zone 'utc'),
  PRIMARY KEY (contract_id)
);
-- table info
SELECT ordinal_position, column_name, data_type, table_name, table_schema FROM information_schema.columns
WHERE table_schema = 'data_raw' AND table_name = 'contract' ORDER BY ordinal_position ASC
;


-- raw product
CREATE TABLE IF NOT EXISTS
data_raw.product(
  product_id char(25),
  product_name char(25),
  deposit char(25),
  total_price char(25),
  payment_frequency char(25),
  payment_amount char(25),
  etl_time char(50) DEFAULT (NOW() AT TIME zone 'utc'),
  PRIMARY KEY (product_id)
);
-- table info
SELECT ordinal_position, column_name, data_type, table_name, table_schema FROM information_schema.columns
WHERE table_schema = 'data_raw' AND table_name = 'product' ORDER BY ordinal_position ASC
;


-- raw transaction
CREATE TABLE IF NOT EXISTS
data_raw.transaction(
  transaction_id char(25),
  contract_id char(25),
  transaction_status char(25),
  transaction_type char(25),
  transaction_amount char(25),
  transaction_date char(25),
  etl_time char(50) DEFAULT (NOW() AT TIME zone 'utc'),
  PRIMARY KEY (transaction_id)
);
-- table info
SELECT ordinal_position, column_name, data_type, table_name, table_schema FROM information_schema.columns
WHERE table_schema = 'data_raw' AND table_name = 'transaction' ORDER BY ordinal_position ASC
;


