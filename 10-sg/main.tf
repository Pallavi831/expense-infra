module "mysql_sg" {
    source = "git::https://github.com/Pallavi831/terraform-aws-securitygroup.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_name = "mysql"
    vpc_id = local.vpc_id
    common_tags = var.common_tags
    sg_description = "Security group for Mysql"
    sg_tags = var.mysql_sg_tags
}

module "bastion_sg" {
    source = "git::https://github.com/Pallavi831/terraform-aws-securitygroup.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_name = "bastion"
    vpc_id = local.vpc_id
    common_tags = var.common_tags
    sg_description = "Security group for Bastion Host"
    sg_tags = var.bastion_sg_tags
}

module "node_sg" {
    source = "git::https://github.com/Pallavi831/terraform-aws-securitygroup.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_name = "node"
    vpc_id = local.vpc_id
    common_tags = var.common_tags
    #sg_description = "Security group for node"
}

module "eks_control_plane_sg" {
    source = "git::https://github.com/Pallavi831/terraform-aws-securitygroup.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_name = "eks-control-plane"
    vpc_id = local.vpc_id
    common_tags = var.common_tags
    sg_description = "Security group for eks control plane"
}

module "ingress_alb_sg" {
    source = "git::https://github.com/Pallavi831/terraform-aws-securitygroup.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_name = "ingress-alb"
    vpc_id = local.vpc_id
    common_tags = var.common_tags
    sg_description = "Security group for ingress alb"
}

resource "aws_security_group_rule" "ingress_alb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.ingress_alb_sg.id
}

resource "aws_security_group_rule" "node_ingress_alb" {
  type              = "ingress"
  from_port         = 30000
  to_port           = 32767
  protocol          = "tcp"
  source_security_group_id = module.ingress_alb_sg.id
  security_group_id = module.node_sg.id
}

resource "aws_security_group_rule" "node_eks_control_plane" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = module.eks_control_plane_sg.id
  security_group_id = module.node_sg.id
}

resource "aws_security_group_rule" "eks_control_plane_node" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = module.node_sg.id
  security_group_id = module.eks_control_plane_sg.id
}

resource "aws_security_group_rule" "eks_control_plane_bastion" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.id
  security_group_id = module.eks_control_plane_sg.id
}

resource "aws_security_group_rule" "node_vpc" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = ["10.0.0.0/16"]
  security_group_id = module.node_sg.id
}

resource "aws_security_group_rule" "node_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.id
  security_group_id = module.node_sg.id
}

resource "aws_security_group_rule" "mysql_bastion" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id       = module.bastion_sg.id
  security_group_id = module.mysql_sg.id
}


resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.bastion_sg.id
}

resource "aws_security_group_rule" "mysql_node" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.node_sg.id
  security_group_id = module.mysql_sg.id
}