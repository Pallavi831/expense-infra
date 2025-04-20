# resource "aws_ssm_parameter" "web_alb_certificate_arn" {
#   name  = "/${var.project_name}/${var.environment}/web_alb_certificate_arn"
#   type  = "String"
#   value = aws_lb_listener.https.arn
# }

resource "aws_ssm_parameter" "web_alb_certificate_arn" {
  name  = "/${var.project_name}/${var.environment}/web_alb_certificate_arn"
  type  = "String"
  value = local.ingress_alb_certificate_arn  # <- Store the certificate ARN here, not the listener ARN
}
