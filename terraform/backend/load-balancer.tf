
locals {
  ports_in = [
    443,
    80
  ]
  ports_out = [
    0
  ]
}

resource "aws_security_group" "internet_facing_alb" {
  name        = format("%v-%v-internetfacing-backend-sg", var.project_name, var.environment)
  description = "Security group attached to internet facing loadbalancer"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = toset(local.ports_in)
    content {
      description = "Web Traffic from internet"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  dynamic "egress" {
    for_each = toset(local.ports_out)
    content {
      description = "Web Traffic to internet"
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  tags = {
    Name = format("%v-%v-internetfacing-backend-sg", var.project_name, var.environment)
  }
}

resource "aws_lb" "internet_facing_alb" {
  name               = format("%v-%v-backend-lg", var.project_name, var.environment)
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.internet_facing_alb.id]
  subnets            = var.public_subnets

}

resource "aws_lb_listener" "alb_port80" {
  load_balancer_arn = aws_lb.internet_facing_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "alb_port443" {
  load_balancer_arn = aws_lb.internet_facing_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_8080.arn
  }
}

resource "aws_lb_target_group" "tg_8080" {
  name        = format("%v-%v-8080-tg", var.project_name, var.environment)
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    path                = "/"
    port                = 8080
    protocol            = "HTTP"
    matcher             = "200"
    interval            = "30"
    timeout             = "5"
    unhealthy_threshold = "2"
    healthy_threshold   = "5"
  }
}

data "aws_route53_zone" "domain" {
  name = var.domain_name
}

resource "aws_route53_record" "cutshort_test_record" {
  zone_id    = data.aws_route53_zone.domain.zone_id
  name       = var.backend_domain
  type       = "CNAME"
  ttl        = "300"
  records    = [format("dualstack.%v", aws_lb.internet_facing_alb.dns_name)]
  depends_on = [aws_lb_target_group.tg_8080]
}