#resource "aws_lb" "minecloud" {
#  name               = "minecloud-alb"
#  load_balancer_type = "application"
#  internal           = false
#  #security_groups    = [aws_security_group.load-balancer.id]
#  subnets            = [aws_subnet.minecloud-frontend.id, aws_subnet.minecloud-frontend2.id]
#}
#
#resource "aws_alb_target_group" "minecloud-tg" {
#  name     = "minecloud-tg"
#  port     = 80
#  protocol = "HTTP"
#  vpc_id   = aws_vpc.minecloud.id
#
#  #health_check {
#  #  path                = var.health_check_path
#  #  port                = "traffic-port"
#  #  healthy_threshold   = 5
#  #  unhealthy_threshold = 2
#  #  timeout             = 2
#  #  interval            = 5
#  #  matcher             = "200"
#  #}
#}
#
#resource "aws_alb_listener" "ecs-alb-http-listener" {
#  load_balancer_arn = aws_lb.minecloud.id
#  port              = "80"
#  protocol          = "HTTP"
#  depends_on        = [aws_alb_target_group.minecloud-tg]
#
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_alb_target_group.minecloud-tg.arn
#  }
#}
