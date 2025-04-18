locals {
  resource_name = "${var.project_name}-${var.environment}-1"
  mysql_sg_id = data.aws_ssm_parameter.mysql_sg_id.value
  database_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
}