# Codex Data Platform

This repository contains an example setup for a GCP based data platform.
It demonstrates how to deploy Spark jobs on Dataproc and orchestrate them
with Airflow running on Kubernetes. Buckets are provisioned for scripts
and data following the layout described in the blueprint documents.

## Structure

- `scripts/fw` – Spark Scala framework and compiled jars
- `scripts/airflow/dag` – Airflow DAGs
- `scripts/airflow/config` – Job configuration files
- `infrastructure/terraform` – Terraform scripts for GCP resources
- `infrastructure/k8s` – Kubernetes manifests

Update the Terraform variables with your GCP project before applying.

## Building and Uploading the Spark Framework Jar

1. Compile the Scala code in `scripts/fw/scripts` using your preferred build
   tool (for example `sbt package` or `mvn package`).
2. Copy the resulting jar to `scripts/fw/lib/output/` and upload it to your
   GCS bucket:

   ```bash
   gsutil cp path/to/framework.jar gs://<your-bucket>/fw/lib/output/framework.jar
   ```
3. Set the `FRAMEWORK_JAR` environment variable to the GCS path of the jar or
   update `scripts/airflow/config/job_config.yaml` with a `jar_path` entry. The
   sample DAG uses this value when submitting the Dataproc job.
