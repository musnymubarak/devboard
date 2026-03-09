# Application Load Balancer
resource "aws_lb" "main" {
  name               = "${var.project}-alb-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = [var.public_subnet_id]

  enable_deletion_protection = false

  tags = { Name = "${var.project}-alb-${var.environment}" }
}

# Target Group — forwards to K8s NodePort 30080
resource "aws_lb_target_group" "main" {
  name     = "${var.project}-tg-${var.environment}"
  port     = 30080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/healthz"
    port                = "30080"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 30
  }

  tags = { Name = "${var.project}-tg-${var.environment}" }
}

# HTTP Listener — redirects to HTTPS
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}