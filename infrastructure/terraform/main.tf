provider "google" {
  project = var.project_id
  region  = var.region
}

module "gcs" {
  source         = "./modules/gcs"
  scripts_bucket = var.scripts_bucket
  data_bucket    = var.data_bucket
  region         = var.region
}

module "dataproc" {
  source = "./modules/dataproc"
  name   = "spark-cluster"
  region = var.region
}

module "gke" {
  source = "./modules/gke"
  name   = "airflow-gke"
  region = var.region
}

module "bigquery" {
  source  = "./modules/bigquery"
  dataset = "metadata"
  region  = var.region
}
