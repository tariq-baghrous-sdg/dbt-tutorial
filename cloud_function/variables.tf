variable "product_spec" {
    type = string
    description = "path to product_spec.yml file in the Product repository"
}

variable "env" {
    type = string
    validation {
        condition = contains(["test", "prod", "coll"], var.env)
        error_message = "env must be test or prod or coll"
    }
}

