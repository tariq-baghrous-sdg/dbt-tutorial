terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.31.0"
    }
  }
}

data "google_storage_bucket" "function_bucket" {
  name = var.bucket_name
}

data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = "."
  output_path = "function-source.zip"
}

resource "google_storage_bucket_object" "function_code" {
  name   = "function-source.zip"
  bucket = data.google_storage_bucket.function_bucket.name
  source = data.archive_file.function_zip.output_path
}

resource "google_cloudfunctions2_function" "hello" {
  name        = "hello-world"
  location    = var.region
  project     = var.project_id
  # kms_key_name = "projects/credem-hubble-pocedp-coll/locations/europe-west8/keyRings/cypherkey-hsm-coll-west8/cryptoKeys/cypherkey-hsm-coll-west8"

  build_config {
    runtime     = "python310"
    entry_point = "main"
    source {
      storage_source {
        bucket = data.google_storage_bucket.function_bucket.name
        object = google_storage_bucket_object.function_code.name
      }
    }
  }

  service_config {
    available_memory = "256M"
    timeout_seconds  = 60
    ingress_settings = "ALLOW_INTERNAL_AND_GCLB"
  }

}