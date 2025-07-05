"""Sample DAG submitting a Spark job to Dataproc.

The path to the compiled jar can be provided via the FRAMEWORK_JAR
environment variable or the ``jar_path`` field inside the YAML
configuration file.
"""

from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime
import os
import yaml

CONFIG_FILE = os.environ.get(
    "JOB_CONFIG_FILE",
    "/opt/airflow/config/job_config.yaml",
)

with open(CONFIG_FILE) as cfg:
    config = yaml.safe_load(cfg)

JAR_PATH = os.environ.get("FRAMEWORK_JAR", config.get("jar_path"))
INPUT_PATH = config.get("input_path")
OUTPUT_PATH = config.get("output_path")

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
            f"--jars {JAR_PATH} --class SimpleJob "
            "gs://ntt-test-data-bq-looker-scripts/fw/scripts/SimpleJob.scala "
            "-- {{ params.input_path }} {{ params.output_path }}"
        ),
        params={"input_path": INPUT_PATH, "output_path": OUTPUT_PATH},
    )
