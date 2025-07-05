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

1. From the `scripts/fw/scripts` directory build the Scala sources using
   [sbt](https://www.scala-sbt.org/) or Maven:

   ```bash
   sbt package            # or: mvn package
   ```
2. Copy the generated jar to `scripts/fw/lib/output/framework.jar` and upload
   it to the bucket path used by the Airflow DAG:

   ```bash
   gsutil cp target/scala-*/*.jar \
     gs://ntt-test-data-bq-looker-scripts/fw/lib/output/framework.jar
   ```
3. Set the `FRAMEWORK_JAR` environment variable to this GCS path or update
   `scripts/airflow/config/job_config.yaml` with the `jar_path`. The sample DAG
   references this value when submitting the Dataproc job.

## Terraform usage

Install [Terraform](https://www.terraform.io/) version **1.0** or newer before
running any formatting or apply commands. After editing the infrastructure
files, you can format and initialize the working directory using:

```bash
terraform fmt
terraform init
```

When applying the configuration, provide the required variables:

```bash
terraform apply -var="project_id=<your-gcp-project>" \
  -var="region=asia-southeast1"
```

## Deploying Airflow on GKE

1. Authenticate `kubectl` against the newly created cluster:

   ```bash
   gcloud container clusters get-credentials airflow-gke \
     --region asia-southeast1 --project <your-gcp-project>
   ```
2. Apply the manifest that fetches DAGs and launches Airflow:

   ```bash
   kubectl apply -f infrastructure/k8s/airflow.yaml
   ```

