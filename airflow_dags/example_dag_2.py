"""
Code that goes along with the Airflow located at:
http://airflow.readthedocs.org/en/latest/tutorial.html
"""
import json
import logging
import subprocess

from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from datetime import datetime, timedelta

from airflow.operators.python_operator import PythonOperator

from json_logger import setup_logging, set_log_record_field

setup_logging(
    service_name='airflow',
    environment_name='dev'
)
log: logging = logging.getLogger(__name__)


def pp(o):
    return json.dumps(o, indent=2, default=str)


default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "start_date": datetime.now() + timedelta(seconds=10),
    "end_date": datetime.now() + timedelta(seconds=120),
    "email": ["airflow@airflow.com"],
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 0,
    "retry_delay": timedelta(seconds=10),
}

dag2 = DAG(
    dag_id="sale_report",
    catchup=False,
    default_args=default_args,
    schedule_interval=timedelta(seconds=30),
    is_paused_upon_creation=False
)

log.info(f"DAG INIT: {pp(dag2.__dict__)}")

# t1, t2 and t3 are examples of tasks created by instantiating operators
# res = subprocess.call(["make", "--directory", "/usr/local/airflow", "test2"])
# log.info(f"EXEC RESULTS: {res.__dict__}")


def schema_init():
    res = subprocess.call(["make", "--directory", "/usr/local/airflow", "test2"])
    log.info(f"EXEC RESULTS: {res.__dict__}")


t1 = BashOperator(task_id="start_log", bash_command="date", dag=dag2)
t3 = BashOperator(task_id="finish_log", bash_command="date", dag=dag2)

t2 = PythonOperator(
    dag=dag2,
    task_id="schema_init",
    python_callable=schema_init,
    provide_context=True
)
log.info(f"T2 INIT: {pp(t2)}")

t3.set_upstream(t2)
t2.set_upstream(t1)
