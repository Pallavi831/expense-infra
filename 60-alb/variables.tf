# Project-related variables
variable "project_name" {
   default = "expense"
}

variable "environment" {
   default = "dev"
}

# Common tags to be applied to resources
variable "common_tags" {
    default = {
        project     = "expense"
        environment = "dev"
        terraform   = "true"
    }
}

# Route53 zone details
variable "zone_id" {
   default = "Z01493333OTCQL5SPZ0M1"
}

variable "domain_name" {
   default = "rushika.site"
}

