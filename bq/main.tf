provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_bigquery_dataset" "datasets" {
  for_each = toset(var.datasets)
  dataset_id                  = each.value
  location                    = var.region
  delete_contents_on_destroy = true
}