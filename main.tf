locals {
  spec       = yamldecode(file(var.config))
  info       = local.spec.info
  project_id = local.info.projects[var.env]
  cf_dev     = local.spec.cloud_function[var.env]
  functions  = local.cf_dev.functions
}

resource "google_storage_bucket" "bundle_bucket" {
  count                       = local.cf_dev.bucket.create_new == true ? 1 : 0
  name                        = "${local.cf_dev.bucket.name}-${var.env}"
  project                     = local.project_id
  location                    = local.cf_dev.bucket.location
  uniform_bucket_level_access = true
}

module "cloud_function" {

  source                = "./cloud-function"
  for_each              = local.functions
  v2                    = each.value.version == 1 ? false : true
  project_id            = local.project_id
  region                = each.value.region
  name                  = "${each.value.name}-${var.env}"
  bucket_name           = local.cf_dev.bucket.create_new == true ? "${local.cf_dev.bucket.name}-${var.env}" : local.cf_dev.bucket.name
  description           = each.value.description
  trigger_config        = each.value.trigger_config
  secrets               = try(each.value.secrets, {})
  environment_variables = each.value.env_variables
  ingress_settings      = each.value.ingress_settings

  function_config = {
    runtime         = try(each.value.runtime, "python310")
    timeout_seconds = try(each.value.timeout_seconds, 180)
    entry_point     = try(each.value.entry_point, "main")
    memory_mb       = try(each.value.memory_mb, 256)
    instance_count  = try(each.value.max_instances, 1)
    available_cpu   = try(each.value.available_cpu, 1)
  }

  service_account = "${local.info.service_account}@${local.project_id}.iam.gserviceaccount.com"
  bundle_config = {
    source_dir  = each.value.source_folder
    output_path = "bundle-${each.value.name}.zip"
  }
  vpc_connector        = try(each.value.vpc_connector, null)
  vpc_connector_config = try(each.value.vpc_connector_config, null)
  depends_on           = [google_storage_bucket.bundle_bucket]
}





