# GCP Data Platform Project Structure

```
gcp-data-platform/
├── terraform/                      # Infrastructure as Code
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── modules/
│   │   ├── gcs/
│   │   ├── dataproc/
│   │   ├── bigquery/
│   │   └── gke/
│   └── environments/
│       └── prod/
├── framework/                      # Spark Scala Framework
│   ├── build.sbt
│   ├── project/
│   ├── src/
│   │   └── main/
│   │       └── scala/
│   │           └── com/
│   │               └── ntt/
│   │                   └── dataplatform/
│   │                       ├── Main.scala
│   │                       ├── connectors/
│   │                       ├── transformers/
│   │                       ├── validators/
│   │                       ├── sinks/
│   │                       └── utils/
│   └── scripts/
├── airflow/                        # Airflow DAGs and Configs
│   ├── dags/
│   │   ├── data_pipeline_dag.py
│   │   └── common/
│   ├── configs/
│   │   ├── pipeline_customer.yaml
│   │   └── pipeline_product.yaml
│   └── plugins/
├── k8s/                           # Kubernetes Manifests
│   ├── namespace.yaml
│   ├── airflow/
│   │   ├── airflow-webserver.yaml
│   │   ├── airflow-scheduler.yaml
│   │   ├── airflow-worker.yaml
│   │   └── airflow-configmap.yaml
│   ├── logging/
│   │   ├── fluentbit-configmap.yaml
│   │   ├── fluentbit-daemonset.yaml
│   │   └── elasticsearch.yaml
│   └── monitoring/
│       ├── prometheus.yaml
│       └── grafana.yaml
├── scripts/                       # Utility Scripts
│   ├── deploy.sh
│   ├── build-framework.sh
│   └── sync-to-gcs.sh
└── README.md
```

## Key Components:

1. **Terraform**: สร้าง GCS buckets, Dataproc cluster, BigQuery datasets, และ GKE cluster
2. **Framework**: Spark Scala framework ที่เป็น configuration-driven
3. **Airflow**: DAGs และ configs สำหรับ orchestration
4. **K8s**: Manifests สำหรับ deploy Airflow และ logging/monitoring stack
5. **Scripts**: Utility scripts สำหรับ deployment และ operations