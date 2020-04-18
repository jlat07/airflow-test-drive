"""
Code that goes along with the Airflow located at:
http://airflow.readthedocs.org/en/latest/tutorial.html
"""
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from datetime import datetime, timedelta


default_args = {
    "owner": "marwamc",
    "depends_on_past": False,
    "email": ["mmarwa@dont.email"],
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5)
}

dag = DAG("example_dag_1",
            default_args=default_args,
            start_date=datetime.now(),
            end_date=datetime.now() - timedelta(minutes=10),
             schedule_interval=timedelta(minutes=1)
          )

# t1, t2 and t3 are examples of tasks created by instantiating operators
t1 = BashOperator(task_id="print_date", bash_command="date", dag=dag)

t2 = BashOperator(task_id="sleep", bash_command="sleep 5", retries=3, dag=dag)

t3 = BashOperator(task_id="pwd_ls", bash_command="printf '\n\npwd\n'; ls -lrt", dag=dag)

t2.set_upstream(t1)
t3.set_upstream(t1)
