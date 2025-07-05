output "scripts_bucket" {
  value = google_storage_bucket.scripts.url
}

output "data_bucket" {
  value = google_storage_bucket.data.url
}
