# Top section copied from http://clarkgrubb.com/makefile-style-guide
MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -o errexit -o nounset -o pipefail -c
.DEFAULT_GOAL := etl_4
.DELETE_ON_ERROR:
.SUFFIXES:

#VARS
docker_exec := docker exec -it peg_etl psql -eb -U postgres -d peg_db
LOC := ${AIRFLOW_HOME}/sql_dags/contract_status
PSQL := psql --host etl_db --port 5432 \
			--username=etl \
			--dbname etl_db \
			--echo-errors  --echo-queries

# TARGETS
test:
	${PSQL} -f ${LOC}/schema_management/data_raw.sql

schema_init:
	${PSQL} -f ${LOC}/schema_management/data_raw.sql
	${PSQL}  -f ${LOC}/schema_management/data_staging.sql
	${PSQL}  -f ${LOC}/schema_management/data_intermediate.sql
	${PSQL}  -f ${LOC}/schema_management/finance.sql
	$(MAKE) sleep

etl_1: schema_init
	${PSQL}  -f ${LOC}/etl_1_raw/etl_raw_data.sql
	$(MAKE) sleep


etl_2: etl_1
	#docker exec -it peg_etl bash -c " cat ${LOC}/etl_2_staging/*.sql | psql -eb -U postgres -d peg_db"
	${PSQL}  -f ${LOC}/etl_2_staging/contract.sql
	${PSQL}  -f ${LOC}/etl_2_staging/customer.sql
	${PSQL}  -f ${LOC}/etl_2_staging/product.sql
	${PSQL}  -f ${LOC}/etl_2_staging/transaction_deposit.sql
	${PSQL}  -f ${LOC}/etl_2_staging/transaction_payment.sql
	$(MAKE) sleep

etl_3: etl_2
	${PSQL}  -f ${LOC}/etl_3_intermediate/contract_start_date.sql
	${PSQL}  -f ${LOC}/etl_3_intermediate/contract_payment_summary.sql
	${PSQL}  -f ${LOC}/etl_3_intermediate/contract_deposit_summary.sql
	${PSQL}  -f ${LOC}/etl_3_intermediate/contract_projection.sql

etl_4: etl_3
	${PSQL}  -f ${LOC}/etl_4_finance/contract_status.sql

analysis:
	${PSQL}  -x -c "SELECT * FROM finance.contract_status"

sleep:
	@echo "Will sleep for 2 seconds"
	$$(sleep 2)
