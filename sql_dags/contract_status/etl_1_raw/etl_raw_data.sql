BEGIN;

-- load customers
COPY
data_raw.customer(customer_id,first_name,last_name)
FROM '/usr/local/airflow/sql_dags/contract_status/raw_data/Customer.csv'
DELIMITER ',' CSV HEADER
;

-- load contract
COPY
data_raw.contract(contract_id,customer_id,product_id,created_at)
FROM '/usr/local/airflow/sql_dags/contract_status/raw_data/Contract.csv'
DELIMITER ',' CSV HEADER
;

-- load product
COPY
data_raw.product(product_id,product_name,deposit,total_price,payment_frequency,payment_amount)
FROM '/usr/local/airflow/sql_dags/contract_status/raw_data/Product.csv'
DELIMITER ',' CSV HEADER
;

-- load transaction
COPY
data_raw.transaction(transaction_id,contract_id,transaction_status,transaction_type,transaction_amount,transaction_date)
FROM '/usr/local/airflow/sql_dags/contract_status/raw_data/Transaction.csv'
DELIMITER ',' CSV HEADER
;

COMMIT;

