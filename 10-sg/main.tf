module "mysql_sg" {
  source          = "git::https://github.com/dev-ops-cloud/terraform-aws-securitygroup.git?ref=main"
  project_name    = var.project_name
  environment     = var.environment
  sg_name         = "mysql"
  sg_description  = "created for MySQL instances in expense dev"
  vpc_id          = data.aws_ssm_parameter.vpc_id.value
  common_tags     = var.common_tags
}

module "bastion_sg" {
  source          = "git::https://github.com/dev-ops-cloud/terraform-aws-securitygroup.git?ref=main"
  project_name    = var.project_name
  environment     = var.environment
  sg_name         = "bastion"
  sg_description  = "created for bastion instances in expense dev"
  vpc_id          = data.aws_ssm_parameter.vpc_id.value
  common_tags     = var.common_tags
}

module "alb_ingress_sg" {
  source          = "git::https://github.com/dev-ops-cloud/terraform-aws-securitygroup.git?ref=main"
  project_name    = var.project_name
  environment     = var.environment
  sg_name         = "app-alb"
  sg_description  = "created for backend ALB in expense dev"
  vpc_id          = data.aws_ssm_parameter.vpc_id.value
  common_tags     = var.common_tags
}

module "eks_control_plane_sg" {
  source          = "git::https://github.com/dev-ops-cloud/terraform-aws-securitygroup.git?ref=main"
  project_name    = var.project_name
  environment     = var.environment
  sg_name         = "eks-control-plane"
  sg_description  = "created for EKS control plane in expense dev"
  vpc_id          = data.aws_ssm_parameter.vpc_id.value
  common_tags     = var.common_tags
}

module "eks_node_sg" {
  source          = "git::https://github.com/dev-ops-cloud/terraform-aws-securitygroup.git?ref=main"
  project_name    = var.project_name
  environment     = var.environment
  sg_name         = "eks-node"
  sg_description  = "created for EKS nodes in expense dev"
  vpc_id          = data.aws_ssm_parameter.vpc_id.value
  common_tags     = var.common_tags
}

# # -- Security Group Rules --

# # Allow all traffic between EKS control plane and node groups
# resource "aws_security_group_rule" "eks_control_plane_node" {
#   type                     = "ingress"
#   from_port                = 0
#   to_port                  = 0
#   protocol                 = "-1"
#   source_security_group_id = module.eks_node_sg.sg_id
#   security_group_id        = module.eks_control_plane_sg.sg_id
# }

# resource "aws_security_group_rule" "eks_node_eks_control_plane" {
#   type                     = "ingress"
#   from_port                = 0
#   to_port                  = 0
#   protocol                 = "-1"
#   source_security_group_id = module.eks_control_plane_sg.sg_id
#   security_group_id        = module.eks_node_sg.sg_id
# }

# # Allow internal VPC traffic to nodes
# resource "aws_security_group_rule" "node_vpc" {
#   type              = "ingress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = ["10.0.0.0/16"]
#   security_group_id = module.eks_node_sg.sg_id
# }

# # Allow SSH to nodes from Bastion
# resource "aws_security_group_rule" "node_bastion_ssh" {
#   type                     = "ingress"
#   from_port                = 22
#   to_port                  = 22
#   protocol                 = "tcp"
#   source_security_group_id = module.bastion_sg.sg_id
#   security_group_id        = module.eks_node_sg.sg_id
# }

# # Allow MySQL access from Bastion and EKS nodes
# resource "aws_security_group_rule" "mysql_bastion" {
#   type                     = "ingress"
#   from_port                = 3306
#   to_port                  = 3306
#   protocol                 = "tcp"
#   source_security_group_id = module.bastion_sg.sg_id
#   security_group_id        = module.mysql_sg.sg_id
# }

# resource "aws_security_group_rule" "mysql_eks_node" {
#   type                     = "ingress"
#   from_port                = 3306
#   to_port                  = 3306
#   protocol                 = "tcp"
#   source_security_group_id = module.eks_node_sg.sg_id
#   security_group_id        = module.mysql_sg.sg_id
# }

# # Allow SSH to Bastion from public (replace with office CIDR for security)
# resource "aws_security_group_rule" "bastion_public_ssh" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = module.bastion_sg.sg_id
# }

# # Allow HTTP/HTTPS to ALB from public
# resource "aws_security_group_rule" "alb_ingress_http" {
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = module.alb_ingress_sg.sg_id
# }

# resource "aws_security_group_rule" "alb_ingress_https" {
#   type              = "ingress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = module.alb_ingress_sg.sg_id
# }

# # Allow ALB to access EKS nodes (pods) on port 80 and 8080
# resource "aws_security_group_rule" "eks_node_alb_http" {
#   type                     = "ingress"
#   from_port                = 80
#   to_port                  = 80
#   protocol                 = "tcp"
#   source_security_group_id = module.alb_ingress_sg.sg_id
#   security_group_id        = module.eks_node_sg.sg_id
#   description              = "Allow ALB access to EKS nodes on port 80"
# }

# resource "aws_security_group_rule" "eks_node_alb_8080" {
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   source_security_group_id = module.alb_ingress_sg.sg_id
#   security_group_id        = module.eks_node_sg.sg_id
#   description              = "Allow ALB access to EKS nodes on port 8080"
# }

# # Optional: ALB can also talk to control plane if needed
# resource "aws_security_group_rule" "eks_control_plane_bastion" {
#   type                     = "ingress"
#   from_port                = 443
#   to_port                  = 443
#   protocol                 = "tcp"
#   source_security_group_id = module.bastion_sg.sg_id
#   security_group_id        = module.eks_control_plane_sg.sg_id
# }
# Allow EKS control plane <-> node communication
resource "aws_security_group_rule" "eks_control_plane_to_nodes" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = module.eks_control_plane_sg.sg_id
  security_group_id        = module.eks_node_sg.sg_id
}

resource "aws_security_group_rule" "nodes_to_eks_control_plane" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = module.eks_node_sg.sg_id
  security_group_id        = module.eks_control_plane_sg.sg_id
}

# Allow traffic from ALB to EKS nodes (used by Target Groups)
resource "aws_security_group_rule" "alb_to_node_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.alb_ingress_sg.sg_id
  security_group_id        = module.eks_node_sg.sg_id
}

resource "aws_security_group_rule" "alb_to_node_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = module.alb_ingress_sg.sg_id
  security_group_id        = module.eks_node_sg.sg_id
}

resource "aws_security_group_rule" "alb_to_node_8080" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.alb_ingress_sg.sg_id
  security_group_id        = module.eks_node_sg.sg_id
}

# Allow public access to ALB on ports 80 and 443
resource "aws_security_group_rule" "alb_http_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.alb_ingress_sg.sg_id
}

resource "aws_security_group_rule" "alb_https_public" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.alb_ingress_sg.sg_id
}

# Allow SSH to bastion from public (should be restricted in real prod env)
resource "aws_security_group_rule" "ssh_bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion_sg.sg_id
}

# Allow bastion to access EKS nodes via SSH
resource "aws_security_group_rule" "bastion_to_eks_node_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id        = module.eks_node_sg.sg_id
}
