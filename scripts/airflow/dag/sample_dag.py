from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime

with DAG(
    dag_id="sample_spark_job",
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,
    catchup=False,
) as dag:
    run_job = BashOperator(
        task_id="run_spark_job",
        bash_command="gcloud dataproc jobs submit spark --cluster=spark-cluster --jars gs://ntt-test-data-bq-looker-scripts/fw/lib/output/framework.jar --class SimpleJob gs://ntt-test-data-bq-looker-scripts/fw/scripts/SimpleJob.scala",
    )
