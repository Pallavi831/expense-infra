# module "alb" {
#   source = "terraform-aws-modules/alb/aws"
#   internal = false

#   # expense-dev-app-alb
#   name    = "${var.project_name}-${var.environment}-ingress-alb"
#   vpc_id  = data.aws_ssm_parameter.vpc_id.value
#   subnets = local.public_subnet_ids
#   create_security_group = false
#   #ecurity_groups = [local.alb_ingress_sg_id]
#   enable_deletion_protection = false

#   tags = merge(
#     var.common_tags,
#     {
#         Name = "${var.project_name}-${var.environment}-ingress-alb"
#     }
#   )
# }

# resource "aws_lb_listener" "https" {
#   load_balancer_arn = module.alb.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = local.ingress_alb_certificate_arn

#   default_action {
#     type             = "fixed-response"
    
#     fixed_response {
#       content_type = "text/html"
#       message_body = "<h1> Hello, I am from frontend web ALB with HTTPS</h1>"
#       status_code  = "200"
#     }
#   }
# }

# resource "aws_route53_record" "web_alb" {
#   zone_id = var.zone_id
#   name    = "expense-${var.environment}-1.${var.domain_name}"
#   type    = "A"

#  # these are ALB DNS name and zone information
#   alias   {
#     name                   = module.alb.dns_name
#     zone_id                = module.alb.zone_id
#     evaluate_target_health = false
#     }
# }

# resource "aws_lb_listener_rule" "frontend" {
#   listener_arn = aws_lb_listener.https.arn
#   priority     = 10

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.frontend.arn
#   }

#   condition {
#     host_header {
#       values = ["expense-${var.environment}-1.${var.domain_name}"]
#     }
#   }
# }

# resource "aws_lb_target_group" "frontend" {
#   name     = local.resource_name
#   port     = 8080
#   protocol = "HTTP"
#   vpc_id   = local.vpc_id
#   deregistration_delay = 60
#   target_type = "ip"

#   health_check {
#     healthy_threshold = 2
#     unhealthy_threshold = 2
#     timeout = 5
#     protocol = "HTTP"
#     port = 8080
#     path = "/"
#     matcher = "200-299"
#     interval = 10
#   }

# }

module "ingress_alb" {
  source = "terraform-aws-modules/alb/aws"

  internal = false
  name    = "${local.resource_name}-ingress-alb" #expense-dev-app-alb
  vpc_id  = local.vpc_id
  subnets = local.public_subnet_ids
  security_groups = [data.aws_ssm_parameter.ingress_alb_sg_id.value]
  create_security_group = false
  enable_deletion_protection = false
  tags = merge(
    var.common_tags,
    var.ingress_alb_tags
  )
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = module.ingress_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello, I am from Application ALB</h1>"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = module.ingress_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = local.https_certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello, I am from Web ALB HTTPS</h1>"
      status_code  = "200"
    }
  }
}


module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = var.zone_name #daws81s.online
  records = [
    {
      name    = "expense-${var.environment}" 
      type    = "A"
      alias   = {
        name    = module.ingress_alb.dns_name
        zone_id = module.ingress_alb.zone_id # This belongs ALB internal hosted zone, not ours
      }
      allow_overwrite = true
    }
  ]
}

resource "aws_lb_target_group" "expense" {
  name     = local.resource_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    interval = 5
    matcher = "200-299"
    path = "/"
    port = 8080
    protocol = "HTTP"
    timeout = 4
  }
}

resource "aws_lb_listener_rule" "frontend" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 100 # low priority will be evaluated first

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.expense.arn
  }

  condition {
    host_header {
      values = ["expense-${var.environment}.${var.zone_name}"] #expense-dev.rushika.site
    }
  }
}