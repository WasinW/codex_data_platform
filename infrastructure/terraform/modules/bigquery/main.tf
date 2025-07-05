resource "google_bigquery_dataset" "metadata" {
  dataset_id = var.dataset
  location   = var.region
}
