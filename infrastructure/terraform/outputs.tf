output "scripts_bucket" {
  value = google_storage_bucket.scripts.url
}

output "data_bucket" {
  value = google_storage_bucket.data.url
}

output "dataproc_cluster" {
  value = google_dataproc_cluster.spark.cluster_name
}

output "gke_cluster" {
  value = google_container_cluster.gke.name
}
