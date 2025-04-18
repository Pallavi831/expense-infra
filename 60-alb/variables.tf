# variable "project_name" {
#    default = "expense"
# }

# variable "environment" {
#    default = "dev"
# }



# variable "common_tags" {
#     default = {
#         project = "expense"
#         environment = "dev"
#         terraform = "true"
#     }
# }

# variable "zone_id" {
#    default = "Z02887034V5M0478U7X"
# }

# variable "domain_name" {
#    default = "rushika.site"
# }

# variable "zone_name" {
#    default = "rushika.site"
# }

variable "project_name" {
    default = "expense"
}

variable "environment" {
    default = "dev"
}

variable "common_tags" {
    default = {
        Project = "expense"
        Terraform = "true"
        Environment = "dev"
    }
}

variable "ingress_alb_tags" {
    default = {
        Component = "web-alb"
    }
}


variable "zone_name" {
    default = "rushika.site"
}