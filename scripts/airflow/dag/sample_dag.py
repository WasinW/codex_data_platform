"""Sample DAG submitting a Spark job to Dataproc.

The path to the compiled jar can be provided via the FRAMEWORK_JAR
environment variable or the ``jar_path`` field inside the YAML
configuration file.
"""

from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.utils.task_group import TaskGroup
from datetime import datetime
import yaml
import os

CONFIG_PATH = os.path.join('/opt/airflow/config', 'job_config.yaml')

with open(CONFIG_PATH) as f:
    cfg = yaml.safe_load(f)

INPUT_PATH = cfg['input_path']
OUTPUT_PATH = cfg['output_path']

with DAG(
    dag_id="sample_spark_job",
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,
    catchup=False,
) as dag:
    run_job = BashOperator(
        task_id="run_spark_job",
        bash_command=(
            "gcloud dataproc jobs submit spark --cluster=spark-cluster "
            "--jars gs://ntt-test-data-bq-looker-scripts/fw/lib/output/framework.jar "
            "--class com.example.jobs.SimpleJob -- \"%s\" \"%s\""
            % (INPUT_PATH, OUTPUT_PATH)
        ),
    )
