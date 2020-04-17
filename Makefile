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
	docker-compose -f airflow-service.yml up

stop:
	docker-compose -f airflow-service.yml down

# make SERVICE=airflow restart
restart:
	docker-compose -f airflow-service.yml restart ${SERVICE}

service-inspect:
	docker network list
	docker exec -it airflow ping postgres -v -c 5

#-----------------------------------------------------------------------------------------
# SECTION: AIRFLOW COMAMNDS
example-search:
	$(MAKE) \
	INDEX='kibana_sample_data_flights' \
	QUERY=@$(PWD)/lucene_queries/flights.json \
	--directory es search
