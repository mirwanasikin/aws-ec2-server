resource "aws_security_group" "sg_k3s_internal" {
  #checkov:skip=CKV2_AWS_5:SG attached to EC2 via vpc_security_group_ids, checkov false positive
  name        = "${var.environment}-sg-k3s-internal"
  description = "Security Group for k3s internal node communication"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.environment}-sg-k3s-internal"
  }
}

resource "aws_security_group" "alb_sg" {
  #checkov:skip=CKV2_AWS_5:SG attached to ALB, checkov false positive
  name        = "${var.environment}-sg-alb"
  description = "Security Group for ALB"
  vpc_id      = var.vpc_id
  tags        = { Name = "${var.environment}-sg-alb" }
}

resource "aws_security_group" "sg_compute" {
  #checkov:skip=CKV2_AWS_5:SG attached to EC2 via vpc_security_group_ids, checkov false positive
  name        = "${var.environment}-sg-compute"
  description = "Security Group for Compute"
  vpc_id      = var.vpc_id
  tags        = { Name = "${var.environment}-sg-compute" }
}

resource "aws_security_group_rule" "alb_ingress_http" {
  #checkov:skip=CKV_AWS_260:Port 80 open intentionally for HTTP traffic via Cloudflare
  security_group_id = aws_security_group.alb_sg.id
  type              = "ingress"
  description       = "HTTP from Internet"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_ingress_https" {
  security_group_id = aws_security_group.alb_sg.id
  type              = "ingress"
  description       = "HTTPS from Internet"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_egress_compute" {
  security_group_id        = aws_security_group.alb_sg.id
  type                     = "egress"
  description              = "Forward to EC2 NodePort"
  from_port                = 30000
  to_port                  = 32767
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg_compute.id
}

resource "aws_security_group_rule" "compute_ingress_alb" {
  security_group_id        = aws_security_group.sg_compute.id
  type                     = "ingress"
  description              = "NodePort from ALB only"
  from_port                = 30000
  to_port                  = 32767
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "compute_ingress_k3s_api" {
  security_group_id = aws_security_group.sg_compute.id
  type              = "ingress"
  description       = "k3s API server - VPC internal only"
  from_port         = 6443
  to_port           = 6443
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr]
}

resource "aws_security_group_rule" "compute_egress_all" {
  #checkov:skip=CKV_AWS_382:Allow all egress required for NAT gateway outbound traffic
  security_group_id = aws_security_group.sg_compute.id
  type              = "egress"
  description       = "Allow all outbound via NAT"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_vpc_security_group_ingress_rule" "flannel_vxlan" {
  security_group_id            = aws_security_group.sg_k3s_internal.id
  description                  = "Flannel VXLAN between k3s nodes"
  from_port                    = 8472
  to_port                      = 8472
  ip_protocol                  = "udp"
  referenced_security_group_id = aws_security_group.sg_k3s_internal.id
}

resource "aws_vpc_security_group_ingress_rule" "k3s_metrics" {
  security_group_id            = aws_security_group.sg_k3s_internal.id
  description                  = "k3s metrics server between nodes"
  from_port                    = 10250
  to_port                      = 10250
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.sg_k3s_internal.id
}
