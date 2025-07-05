# Codex Data Platform

This repository provides a production-grade reference for building a data platform on **Google Cloud Platform**. It provisions infrastructure with Terraform, runs Apache Spark jobs on Dataproc, and orchestrates pipelines with Airflow on Kubernetes.

```
├── scripts
│   ├── airflow
│   │   ├── dag               # Airflow DAGs
│   │   └── config            # YAML configs consumed by DAGs
│   └── fw
│       ├── build.sbt         # Spark/Scala build
│       ├── build.sh          # build script producing lib/output/framework.jar
│       └── src/main/scala    # framework and jobs
├── infrastructure
│   ├── terraform             # IaC for GCS, Dataproc, GKE, BigQuery
│   │   └── modules           # reusable Terraform modules
│   └── k8s                   # Kubernetes manifests and Dockerfile
└── scripts/tools             # helper scripts for deployment and data
```

## Requirements
- Terraform >= 1.0
- Docker and `kubectl`
- sbt for building Scala code
- gcloud SDK authenticated to your project

## Deployment
1. **Build the Spark framework**
   ```bash
   ./scripts/fw/build.sh
   ```
2. **Sync scripts to GCS**
   ```bash
   ./scripts/tools/sync_gcs.sh ntt-test-data-bq-looker-scripts
   ```
3. **Deploy infrastructure and Airflow**
   ```bash
   ./scripts/tools/deploy.sh
   ```

An Airflow web service will be available in the `airflow` namespace. DAGs load configuration from `/opt/airflow/config` which is populated from the scripts bucket on startup.

## Sample Data
Generate sample parquet data for testing:
```bash
python scripts/tools/create_sample_data.py /tmp/sample
```
Upload to the raw layer bucket path as required by your config.

## Contribution
Pull requests are welcome. Please format Terraform with `terraform fmt` and keep code modular and documented.

