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
  #checkov:skip=CKV_AWS_88:Public IP required for Grafana access in dev environment
  for_each               = var.instances
  ami                    = data.aws_ami.amazon.id
  subnet_id              = var.public_subnet_id[each.key]
  availability_zone      = each.value.az
  instance_type          = each.value.instance_type
  iam_instance_profile   = var.iam_instance_profile
  vpc_security_group_ids = [var.security_group_id]

  metadata_options {
    http_tokens                 = "required"
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    encrypted   = true
    volume_type = "gp3"
    volume_size = 20

    tags = {
      Name = "${var.environment}-root-volume"
    }
  }

  tags = {
    Name = "${var.environment}-compute-${each.key}"
    Env  = var.environment
    Role = each.value.role
  }
}
