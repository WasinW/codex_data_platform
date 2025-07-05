resource "google_storage_bucket" "scripts" {
  name     = var.scripts_bucket
  location = var.region
}

resource "google_storage_bucket" "data" {
  name     = var.data_bucket
  location = var.region
}
