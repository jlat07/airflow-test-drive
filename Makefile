# Top section copied from http://clarkgrubb.com/makefile-style-guide
MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -o errexit -o nounset -o pipefail -c
.DEFAULT_GOAL := start
.DELETE_ON_ERROR:
.SUFFIXES:

# VARS
docker_run := docker run -itd --rm

#-----------------------------------------------------------------------------------------
# SECTION: MANAGE SERVICE
start:
	docker-compose -f airflow-service.yml build
	docker-compose -f airflow-service.yml up

stop:
	docker-compose -f airflow-service.yml down

# make SERVICE=airflow shell
# make SERVICE=postgres_airflow shell
shell:
	docker exec -it ${SERVICE} /bin/bash

# make SERVICE=airflow restart
restart:
	docker-compose -f airflow-service.yml restart ${SERVICE}

cat-airflow-logs:
	docker exec -it airflow cat logs/dag_processor_manager/dag_processor_manager.log  #tail -f logs/dag_processor_manager/*.log

service-inspect:
	docker network list
	docker exec -it airflow ping postgres -v -c 5

#-----------------------------------------------------------------------------------------
# SECTION : DEBUG/TEST
run:
	docker run -it --rm --name airflow_test marwamc/docker-airflow:latest bash

# make PGPASSWORD=etl test1
test1:
	psql --host localhost --port 5433 \
	--username=etl \
	--dbname etl_db \
	--echo-errors  --echo-queries \
	-f sql_dags/contract_status/schema_management/data_raw.sql

# make
test2:
	docker exec -it airflow make --directory sql_dags/contract_status
	docker exec -it airflow make --directory sql_dags/contract_status analysis
