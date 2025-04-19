# locals {
#     # stringlist to list
#   public_subnet_ids = split(",", data.aws_ssm_parameter.public_subnet_ids.value)
#   # alb_ingress_sg_id = data.aws_ssm_parameter.alb_ingress_sg_id.value
#   ingress_alb_certificate_arn = data.aws_ssm_parameter.ingress_alb_certificate_arn.value
#   resource_name = "${var.project_name}-${var.environment}-1"
#   vpc_id = data.aws_ssm_parameter.vpc_id.value
# }


# locals {
#     resource_name = "${var.project_name}-${var.environment}"
#     vpc_id = data.aws_ssm_parameter.vpc_id.value
#     public_subnet_ids = split(",", data.aws_ssm_parameter.public_subnet_ids.value)
#     https_certificate_arn = data.aws_ssm_parameter.https_certificate_arn.value
# }

locals {
  resource_name           = "${var.project_name}-${var.environment}"
  vpc_id                  = data.aws_ssm_parameter.vpc_id.value
  public_subnet_ids       = split(",", data.aws_ssm_parameter.public_subnet_ids.value)
  https_certificate_arn   = data.aws_ssm_parameter.https_certificate_arn.value
  alb_ingress_sg_id       = data.aws_ssm_parameter.ingress_alb_sg_id.value
}
