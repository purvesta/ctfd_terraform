resource "aws_lb" "challenge-alb" {
  count = length(var.challenges)
  name               = "${var.challenges[count.index]}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web-challenge-alb-sg.id]
  subnets            = [aws_subnet.challenge-subnet-1.id, aws_subnet.challenge-subnet-2.id]

  enable_deletion_protection = false

#   access_logs {
#     bucket  = aws_s3_bucket.challenge-access.bucket
#     prefix  = "${each.value}-alb"
#     enabled = true
#   }

  tags = {
    Name = "${var.challenges[count.index]}-alb"
  }
}

resource "aws_lb_target_group" "challenge-http-alb-tg" {
  count = length(var.challenges)
  name     = "${var.challenges[count.index]}-http-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.challenges.id

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
  count = length(var.challenges)
  load_balancer_arn = aws_lb.challenge-alb[count.index].arn
  port              = "80"
  protocol          = "HTTP"
  depends_on        = [aws_lb.challenge-alb]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.challenge-http-alb-tg[count.index].arn
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
