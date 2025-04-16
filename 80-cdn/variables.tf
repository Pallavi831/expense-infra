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
   default = "Z05090632KRW9DIHOUMAP"
}

variable "domain_name" {
   default = "rushika.site"
}

variable "zone_name" {
   default = "rushika.site"
}