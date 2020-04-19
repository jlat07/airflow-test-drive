# airflow-test-drive
a simple airflow use case

## System requirements
System requirements to run this test-drive: 
1. GNU Make (usually pre-installed in unix-like systems like Macos, ubuntu etc)
2. Docker
3. Psql

## Test drive
The following commands [`docker-compose`](./airflow-service.yml) a setup with the following containers:
1. airflow (webserver from https://github.com/puckel/docker-airflow)
2. airflow_db (postgres)
3. etl_db (postgres)

The airflow service is run in LOCAL_EXECUTOR mode, and it's backend is the `airflow_db`.

The goal is to use the airflow service to execute this [`example etl process which in this example is executed using make targets`](https://github.com/marwamc/etl-by-makefile#what-is-being-solved).

NOTE: the airflow service is not yet running the etl process described above.

```
make start
make service-inspect
make cat-airflow-logs
make PGPASSWORD=etl test1
make test2
make stop
```

## To-do
- [ ] Use PythonOperator/PostgresOperator to execute [this etl](./sql_dags/contract_status/Makefile)
- [ ] Pip or Clone [sample etl](https://github.com/marwamc/etl-by-makefile/tree/master/dag) 
instead of manually mounting/uploading the directory into airflow server container
- [ ] Research airflow sql table templates
- [ ] Speed up the airflow dags - extremely slow
- [ ] Deploy stack to a local kubernetes cluster


## References
[Dockerized airflow](https://github.com/puckel/docker-airflow)

[Example etl DAG](https://github.com/marwamc/etl-by-makefile/blob/master)
