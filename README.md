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

## Terraform usage

Install [Terraform](https://www.terraform.io/) version **1.0** or newer before
running any formatting or apply commands. After editing the infrastructure
files, you can format and initialize the working directory using:

```bash
terraform fmt
terraform init
```

Then apply the configuration with `terraform apply`.
