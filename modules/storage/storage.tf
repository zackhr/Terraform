resource "google_storage_bucket" "storage-bucket" {
  name          = "terf-tf-bucket"
  location      = "us"
  force_destroy = true
  uniform_bucket_level_access = true
}
