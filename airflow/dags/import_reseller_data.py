from datetime import timedelta, datetime 
import pytz 
from airflow import DAG 
from airflow.operators.python_operator import PythonOperator 
from airflow.operators.postgres_operator import PostgresOperator 
from airflow.utils.dates import days_ago 
from airflow.hook.postgres_hook import PostgresHook 
from airflow.sensors.external_task_sensor import ExternalTaskSensor 

import os 
import pandas as pd 
import json 
import xmltodict 

default_args = {
    'owner': 'airflow',
    'depends_on_past': False, 
    'email': ['airflow@example.com'],
    'email_on_failure': False, 
    'email_on_retry': False, 
    'retries': 1, 
    'retry_delay': timedelta(minutes=5)
}