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
	docker-compose -f docker-compose.yml up

stop:
	docker-compose -f docker-compose.yml down

ping-es:
	curl -v "localhost:9200/_cat/nodes?v&pretty"
	curl -v "localhost:9200/_cat/indices?v&pretty"

network-inspect:
	docker network list
	docker network inspect presto-n
	docker exec -it kibana ping es -v -c 5

#-----------------------------------------------------------------------------------------
# SECTION: ELASTIC QUERIES
example-search:
	$(MAKE) \
	INDEX='kibana_sample_data_flights' \
	QUERY=@$(PWD)/lucene_queries/flights.json \
	--directory es search

