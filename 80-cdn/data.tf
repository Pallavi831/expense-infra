# data "aws_cloudfront_cache_policy" "noCache" {
#    name = "Managed-CachingDisabled"
# }

# data "aws_cloudfront_cache_policy" "CacheEnable" {
#    name = "Managed-CachingOptimized"
# }

# data "aws_ssm_parameter" "https_certificate_arn" {
#   name  = "/${var.project_name}/${var.environment}/web_alb_certificate_arn"
# }

# data "aws_ssm_parameter" "https_certificate_arn" {
#   name = "/${var.project_name}/${var.environment}/https_certificate_arn"
# }


data "aws_cloudfront_cache_policy" "noCache" {
   name = "Managed-CachingDisabled"
}

data "aws_cloudfront_cache_policy" "CacheEnable" {
   name = "Managed-CachingOptimized"
}

# Rename one of the duplicate data sources
data "aws_ssm_parameter" "web_alb_certificate_arn" {
  name  = "/${var.project_name}/${var.environment}/web_alb_certificate_arn"
}

data "aws_ssm_parameter" "https_certificate_arn" {
  name = "/${var.project_name}/${var.environment}/https_certificate_arn"
}
