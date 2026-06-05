data "aws_ami" "amazon" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "main" {
  #checkov:skip=CKV_AWS_135:EBS optimization not supported on t-series instances
  #checkov:skip=CKV_AWS_126:Detailed monitoring not required for dev environment
  ami                    = data.aws_ami.amazon.id
  subnet_id              = var.public_subnet_id
  instance_type          = var.instance_type
  iam_instance_profile   = var.iam_instance_profile
  vpc_security_group_ids = [var.security_group_id]

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted = true
  }

  tags = {
    Name = "${var.environment}-server"
    Env  = var.environment
  }
}
