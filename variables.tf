variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  default     = "europe-west8"
}

variable "bucket_name" {
  type        = string
  description = "Name of the GCS bucket to upload the function source"
}
