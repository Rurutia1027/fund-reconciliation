import json 

from airflow import DAG
from airflow.operators.bash import BashOperator 
from airflow.utils.dates import days_ago 
from airflow.sensors.external_task_sensor import ExternalTaskSensor 

dag = DAG(
    dag_id = "run_dbt_model",
    start_date = days_ago(1),
    description = "A dbt wrapper for Airflow",
    schedule_interval = '@daily'
)

DBT_PATH = '/usr/local/airflow/dbt'
DBT_BIN='/usr/local/bin/dbt'

wait_for_dbt_init = ExternalTaskSensor(
    task_id = 'wait_for_dbt_init',
    external_dag_id='run_dbt_init_tasks',
    
)