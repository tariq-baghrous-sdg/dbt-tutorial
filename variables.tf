variable "config" {
    type = string
    description = "path to config.yml file"
}

variable "env" {
    type = string
    validation {
        condition = contains(["dev", "prd"], var.env)
        error_message = "env must be dev or prd"
    }
}

