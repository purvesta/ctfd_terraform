resource "aws_lb" "ctfd-alb" {
  name               = "${var.service}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ctfd-alb-sg.id]
  subnets            = [aws_subnet.ctfd-subnet-1.id, aws_subnet.ctfd-subnet-2.id]

  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.ctfd-access.bucket
    prefix  = "${var.service}-alb"
    enabled = true
  }

  tags = {
    Name = "${var.service}-alb"
  }
}

resource "aws_lb_target_group" "ctfd-http-alb-tg" {
  name     = "${var.service}-http-alb-tg"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = aws_vpc.ctf-interface.id

  health_check {
    interval = 20
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

#resource "aws_lb_target_group" "ctfd-https-alb-tg" {
#  name     = "${var.service}-https-alb-tg"
#  port     = 443
#  protocol = "HTTPS"
#  vpc_id   = aws_vpc.ctf-interface.id
#}

resource "aws_lb_listener" "ctfd-http-alb-ls" {
  load_balancer_arn = aws_lb.ctfd-alb.arn
  port              = "80"
  protocol          = "HTTP"
  depends_on        = [aws_lb.ctfd-alb]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ctfd-http-alb-tg.arn
  }
}

#resource "aws_lb_listener" "ctfd-https-alb-ls" {
#  load_balancer_arn = aws_lb.ctfd-alb.arn
#  port              = "443"
#  protocol          = "HTTPS"
#  certificate_arn   = aws_acm_certificate.ctfd-cert.arn
#
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.ctfd-https-alb-tg.arn
#  }
#}
