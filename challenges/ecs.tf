resource "aws_ecs_cluster" "minecloud" {
  name = "minecloud"
}

resource "aws_ecs_task_definition" "minecloud-task" {
  family                   = "bedrock"
  task_role_arn            = aws_iam_role.ecs-task-role.arn
  execution_role_arn       = aws_iam_role.ecs-task-role.arn
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"
  requires_compatibilities = ["FARGATE"]
  container_definitions    = file("task-definitions/bedrock.json")
  depends_on       = [aws_iam_role.ecs-task-role, aws_efs_file_system.minecloud-fs, aws_efs_access_point.minecloud-efs-ap]
  volume {
    name = "bedrock-efs"
    efs_volume_configuration {
      file_system_id          = aws_efs_file_system.minecloud-fs.id
      transit_encryption      = "ENABLED"
      transit_encryption_port = 2999
      authorization_config {
        access_point_id = aws_efs_access_point.minecloud-efs-ap.id
        iam             = "DISABLED"
      }
    }
  }
}


resource "aws_ecs_service" "bedrock" {
  name            = "bedrock"
  cluster         = aws_ecs_cluster.minecloud.id
  task_definition = aws_ecs_task_definition.minecloud-task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  platform_version = "1.4.0"
  depends_on       = [aws_iam_role.ecs-task-role, aws_security_group.minecloud-sg, aws_efs_mount_target.minecloud-frontend-efs-target, aws_efs_mount_target.minecloud-frontend2-efs-target]

  network_configuration {
    assign_public_ip = "true"
    security_groups  = [aws_security_group.minecloud-sg.id]
    subnets = [aws_subnet.minecloud-frontend.id, aws_subnet.minecloud-frontend2.id]
  }
}
