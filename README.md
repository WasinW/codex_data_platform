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

## Terraform usage

Install [Terraform](https://www.terraform.io/) version **1.0** or newer before
running any formatting or apply commands. After editing the infrastructure
files, you can format and initialize the working directory using:

```bash
terraform fmt
terraform init
```

Then apply the configuration with `terraform apply`.

## Building a Custom Airflow Image

A `Dockerfile` is included which extends `apache/airflow:2.7.0` and
installs the Google Cloud SDK. Build the image and push it to your
Artifact Registry or GCR before applying the Kubernetes manifests:

```bash
# build and tag the image
docker build -t gcr.io/<your-project-id>/airflow-gcloud:2.7.0 .

# push to Artifact Registry or GCR
docker push gcr.io/<your-project-id>/airflow-gcloud:2.7.0
```

The deployment manifest in `infrastructure/k8s/airflow.yaml` references
this image.
