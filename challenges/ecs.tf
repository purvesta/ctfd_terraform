resource "aws_ecs_cluster" "challenges" {
  name = "challenges"
}

resource "aws_ecs_task_definition" "challenge-task" {
  count                    = length(var.challenges)
  family                   = var.challenges[count.index]
  task_role_arn            = aws_iam_role.ecs-task-role.arn
  execution_role_arn       = aws_iam_role.ecs-task-role.arn
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"
  requires_compatibilities = ["FARGATE"]
  container_definitions    = file("${path.module}/task-definitions/${var.challenges[count.index]}.json")
  # depends_on       = [aws_iam_role.ecs-task-role, aws_efs_file_system.minecloud-fs, aws_efs_access_point.minecloud-efs-ap]
  # volume {
  #   name = "bedrock-efs"
  #   # efs_volume_configuration {
  #   #   file_system_id          = aws_efs_file_system.minecloud-fs.id
  #   #   transit_encryption      = "ENABLED"
  #   #   transit_encryption_port = 2999
  #   #   authorization_config {
  #   #     access_point_id = aws_efs_access_point.minecloud-efs-ap.id
  #   #     iam             = "DISABLED"
  #   #   }
  #   # }
  # }
}


resource "aws_ecs_service" "challenge" {
  count           = length(var.challenges)
  name            = var.challenges[count.index]
  cluster         = aws_ecs_cluster.challenges.id
  task_definition = aws_ecs_task_definition.challenge-task[count.index].arn
  desired_count   = 1
  launch_type     = "FARGATE"
  platform_version = "1.4.0"
  depends_on       = [aws_iam_role.ecs-task-role, aws_security_group.web-challenge-sg]

  load_balancer {
    target_group_arn = aws_lb_target_group.challenge-http-alb-tg[count.index].arn
    container_name = var.challenges[count.index]
    container_port = var.container_port
  }
  network_configuration {
    assign_public_ip = "false"
    security_groups  = [aws_security_group.web-challenge-sg.id]
    subnets = [aws_subnet.challenge-subnet-1.id, aws_subnet.challenge-subnet-2.id]
  }
}
