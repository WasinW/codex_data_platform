variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "asia-southeast1"
}

variable "scripts_bucket" {
  type    = string
  default = "ntt-test-data-bq-looker-scripts"
}

variable "data_bucket" {
  type    = string
  default = "ntt-test-data-bq-looker-data"
}
