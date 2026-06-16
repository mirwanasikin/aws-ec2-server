resource "aws_lb" "main" {
  #checkov:skip=CKV_AWS_91:Access logging not required for dev environment
  #checkov:skip=CKV2_AWS_28:WAF not required for dev environment
  #checkov:skip=CKV_AWS_150:Deletion protection not required for dev environment
  #checkov:skip=CKV_AWS_131:Invalid header dropping not required for dev environment
  #checkov:skip=CKV2_AWS_20:HTTPS redirect requires ACM cert, out of scope for dev
  name               = "${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_alb_id]
  subnets            = [for subnet in var.public_subnet_ids : subnet]

  enable_deletion_protection = false
  drop_invalid_header_fields = false

  tags = {
    Name = "${var.environment}-alb"
    Env  = var.environment
  }
}

resource "aws_lb_target_group" "main" {
  #checkov:skip=CKV_AWS_378:HTTP protocol intentional for internal ALB-to-NodePort traffic
  name        = "${var.environment}-tg"
  port        = var.traefik_nodeport
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/health"
    port                = var.traefik_nodeport
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = {
    Name = "${var.environment}-tg"
    Env  = var.environment
  }
}

resource "aws_lb_target_group_attachment" "main" {
  for_each         = var.instance_ids
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = each.value
  port             = var.traefik_nodeport
}

resource "aws_lb_listener" "http" {
  #checkov:skip=CKV_AWS_2:HTTPS redirect requires ACM cert, out of scope for dev
  #checkov:skip=CKV_AWS_91:Access logging not required for dev environment
  #checkov:skip=CKV_AWS_103:TLS not applicable for HTTP listener in dev
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
