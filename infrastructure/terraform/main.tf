provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "scripts" {
  name     = "ntt-test-data-bq-looker-scripts"
  location = var.region
}

resource "google_storage_bucket" "data" {
  name     = "ntt-test-data-bq-looker-data"
  location = var.region
}

resource "google_dataproc_cluster" "spark" {
  name   = "spark-cluster"
  region = var.region

  cluster_config {
    master_config {
      num_instances = 1
      machine_type  = "n1-standard-2"
    }

    worker_config {
      num_instances = 2
      machine_type  = "n1-standard-2"
    }
  }
}

resource "google_container_cluster" "gke" {
  name     = "airflow-gke"
  location = var.region

  remove_default_node_pool = true

  node_config {
    machine_type = "e2-standard-4"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

resource "google_container_node_pool" "gke_nodes" {
  name       = "airflow-pool"
  location   = var.region
  cluster    = google_container_cluster.gke.name

  node_count = 1

  node_config {
    machine_type = "e2-standard-4"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}
