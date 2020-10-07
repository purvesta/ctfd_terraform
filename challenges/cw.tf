resource "aws_cloudwatch_log_group" "bedrock-fargate" {
  name = "/ecs/bedrock-fargate"

  tags = {
    Name = "minecloud"
  }
}
