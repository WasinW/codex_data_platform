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

1. From the `scripts/fw` directory run `sbt package` to compile the Scala
   framework using the provided `build.sbt`.
2. Copy the resulting jar from `scripts/fw/target/scala-2.12/` to
   `scripts/fw/lib/output/framework.jar` and upload it to your GCS bucket:

   ```bash
   gsutil cp path/to/framework.jar gs://<your-bucket>/fw/lib/output/framework.jar
   ```
3. Set the `FRAMEWORK_JAR` environment variable to the GCS path of the jar or
   update `scripts/airflow/config/job_config.yaml` with a `jar_path` entry. The
   sample DAG uses this value when submitting the Dataproc job.

## Terraform usage

Install [Terraform](https://www.terraform.io/) version **1.0** or newer before
running any formatting or apply commands. After editing the infrastructure
files, you can format and initialize the working directory using:

```bash
terraform fmt
terraform init
```

Then apply the configuration with `terraform apply`.
