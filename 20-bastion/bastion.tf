resource "aws_instance" "this" {
  #count = 3
  ami                    = "ami-09c813fb71547fc4f"
  vpc_security_group_ids = [data.aws_ssm_parameter.bastion_sg_id.value]
  instance_type          = "t3.micro"
  subnet_id = local.public_subnet_id
  # 20 GB is not enough
  root_block_device {
    volume_size = 50 # set root volume size to 50GB
    volume_type = "gp3"  # use gp3 for better performance(optional)
  }
  user_data = file("bastion.sh")
  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-bastion"
    }
  )
}

