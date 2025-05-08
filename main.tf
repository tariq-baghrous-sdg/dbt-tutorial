terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.31.0"
    }
  }
}

module "cloud_function" {
  source        = "./cloud_function"
  env           = var.env
  product_spec  = "./config.yml"
}

module "bigquery_datasets" {
  source = "./bq"
}