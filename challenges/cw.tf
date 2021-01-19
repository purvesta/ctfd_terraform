resource "aws_cloudwatch_log_group" "challenges" {
  name = "/ecs/challenges"

  tags = {
    Name = var.service
  }
}
