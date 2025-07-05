output "scripts_bucket" {
  value = module.gcs.scripts_bucket
}

output "data_bucket" {
  value = module.gcs.data_bucket
}

output "dataproc_cluster" {
  value = module.dataproc.cluster_name
}

output "gke_cluster" {
  value = module.gke.cluster_name
}
