# GCP Data Platform

A modern, scalable data platform built on Google Cloud Platform using Spark, Airflow, and Kubernetes.

## 🏗️ Architecture Overview

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Source Data   │────▶│  Data Platform  │────▶│    Analytics    │
│  (DB/Files/API) │     │   (GCS/Spark)   │     │  (BQ/Iceberg)   │
└─────────────────┘     └─────────────────┘     └─────────────────┘
         │                       │                        │
         │                       │                        │
    ┌────▼─────┐          ┌─────▼──────┐         ┌──────▼──────┐
    │  Airflow │          │  Dataproc  │         │   BigQuery  │
    │  on K8s  │          │   Cluster  │         │   Dataset   │
    └──────────┘          └────────────┘         └─────────────┘
```

## 📋 Components

### 1. **Storage Layer**
- **Scripts Bucket**: `ntt-test-data-bq-looker-scripts`
  - Framework JARs: `/fw/lib/output/`
  - Airflow DAGs: `/airflow/dag/`
  - Pipeline Configs: `/airflow/config/`
- **Data Bucket**: `ntt-test-data-bq-looker-data`
  - Raw Layer: `/dp_demo_data/raw/`
  - Structured Layer: `/dp_demo_data/struct/`
  - Refined Layer: `/dp_demo_data/refined/`
  - Analysis Layer: `/dp_demo_data/analysis/`

### 2. **Compute Layer**
- **Dataproc**: Managed Spark clusters for data processing
- **Framework**: Configuration-driven Spark Scala framework

### 3. **Orchestration Layer**
- **Airflow on K8s**: DAG-based pipeline orchestration
- **Dynamic pipeline generation from YAML configs**

### 4. **Metadata & Governance**
- **BigQuery**: Metadata storage and analytics
- **Apache Iceberg**: Table format for data versioning

### 5. **Monitoring & Logging**
- **Prometheus**: Metrics collection
- **Grafana**: Visualization dashboards
- **FluentBit**: Log aggregation

## 🚀 Quick Start

### Prerequisites
- GCP Project with billing enabled
- `gcloud` CLI installed and authenticated
- `kubectl` installed
- `terraform` installed
- `sbt` for Scala build
- Docker (optional, for local testing)

### 1. Clone the Repository
```bash
git clone <repository-url>
cd gcp-data-platform
```

### 2. Configure Environment
```bash
export PROJECT_ID="ntt-test-data-bq-looker"
export REGION="asia-southeast1"
```

### 3. Deploy Infrastructure
```bash
chmod +x scripts/*.sh
./scripts/deploy.sh
```

This will:
- Enable required GCP APIs
- Create GCS buckets
- Deploy Dataproc cluster
- Create GKE cluster
- Deploy Airflow and monitoring stack

### 4. Create Sample Data
```bash
./scripts/create-sample-data.sh
```

### 5. Test Pipeline
```bash
./scripts/test-pipeline.sh
```

## 📝 Creating a Pipeline

### 1. Create Pipeline Configuration
Create a YAML file in `airflow/configs/`:

```yaml
pipeline_name: "my_pipeline"
description: "Description of your pipeline"

source:
  type: "database"  # or "file", "bigquery", "kafka"
  config:
    # Source-specific configuration

transformations:
  - type: "select_columns"
    config:
      columns: ["col1", "col2"]
  # Add more transformations

validation:
  type: "data_quality"
  config:
    not_null_columns: "col1,col2"

sink:
  type: "iceberg"  # or "file", "bigquery", "delta"
  config:
    table: "iceberg.my_dataset.my_table"
```

### 2. Upload Configuration
```bash
gsutil cp my_pipeline.yaml gs://${PROJECT_ID}-scripts/airflow/config/
```

### 3. Trigger Pipeline
The pipeline will be automatically picked up by Airflow on the next DAG run.

## 🔧 Framework Usage

### Supported Connectors
- **Database**: JDBC-compatible databases
- **File**: Parquet, CSV, JSON from GCS
- **BigQuery**: Direct BigQuery integration
- **Kafka**: Streaming data ingestion

### Supported Transformations
- `select_columns`: Select specific columns
- `filter`: Filter rows based on conditions
- `sql`: Execute SQL transformations
- `rename_columns`: Rename columns
- `add_columns`: Add computed columns
- `aggregate`: Group by and aggregate
- `join`: Join with other tables
- `deduplicate`: Remove duplicate rows

### Supported Validators
- `row_count`: Validate row count ranges
- `schema`: Validate required columns
- `data_quality`: Null checks, unique constraints

### Supported Sinks
- `file`: Write to GCS in various formats
- `iceberg`: Write to Iceberg tables
- `bigquery`: Write to BigQuery
- `delta`: Write to Delta Lake

## 🔍 Monitoring

### Airflow UI
Access at: `http://<AIRFLOW_IP>:8080`
- Default credentials: `admin/admin`
- Monitor DAG runs
- View logs
- Manage pipelines

### Grafana Dashboards
Access at: `http://<GRAFANA_IP>:3000`
- Default credentials: `admin/admin`
- Pipeline metrics
- System performance
- Data quality metrics

## 🛠️ Maintenance

### Update Framework
```bash
cd framework
sbt assembly
./scripts/sync-to-gcs.sh
```

### Scale Airflow Workers
```bash
kubectl scale deployment airflow-worker -n data-platform --replicas=4
```

### Update Pipeline Configs
```bash
# Edit config locally
vim airflow/configs/my_pipeline.yaml

# Sync to GCS
./scripts/sync-to-gcs.sh
```

## 🧹 Cleanup

To remove all resources:
```bash
./scripts/cleanup.sh
```

## 📁 Project Structure

```
gcp-data-platform/
├── terraform/              # Infrastructure as Code
├── framework/              # Spark Scala Framework
├── airflow/               # DAGs and Configurations
├── k8s/                   # Kubernetes Manifests
├── scripts/               # Deployment Scripts
└── README.md
```

## 🔐 Security Considerations

1. **Service Accounts**: Separate service accounts for different components
2. **Secrets Management**: Use K8s secrets for sensitive data
3. **Network Security**: Private GKE cluster with authorized networks
4. **Data Encryption**: Encryption at rest and in transit
5. **IAM Roles**: Least privilege principle

## 🎯 Best Practices

1. **Version Control**: All configurations in Git
2. **Testing**: Test pipelines in development first
3. **Monitoring**: Set up alerts for pipeline failures
4. **Documentation**: Document each pipeline's purpose
5. **Data Quality**: Implement validation at each stage

## 📊 Cost Optimization

1. **Dataproc Autoscaling**: Enable for variable workloads
2. **Preemptible VMs**: Use for non-critical workers
3. **Storage Lifecycle**: Move old data to cheaper storage
4. **Schedule Optimization**: Run heavy jobs during off-peak

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

---

## 📞 Support

For issues and questions:
- Create an issue in the repository
- Contact the data platform team

## 🔗 Additional Resources

- [Spark Documentation](https://spark.apache.org/docs/latest/)
- [Airflow Documentation](https://airflow.apache.org/docs/)
- [GCP Documentation](https://cloud.google.com/docs)
- [Iceberg Documentation](https://iceberg.apache.org/docs/latest/)