variable "project_name" {
   default = "expense"
}

variable "environment" {
   default = "dev"
}



variable "common_tags" {
    default = {
        project = "expense"
        environment = "dev"
        terraform = "true"
    }
}

variable "zone_id" {
   default = "Z01493333OTCQL5SPZ0M1"
}

variable "domain_name" {
   default = "rushika.site"
}

# variable "zone_name" {
#    default = "rushika.site"
# }