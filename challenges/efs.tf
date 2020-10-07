resource "aws_efs_file_system" "minecloud-fs" {
  creation_token = "minecloud-fs"
  encrypted      = "true"

  tags = {
    Name = "minecloud"
  }
}

resource "aws_efs_mount_target" "minecloud-frontend-efs-target" {
  file_system_id = aws_efs_file_system.minecloud-fs.id
  subnet_id      = aws_subnet.minecloud-frontend.id
}

resource "aws_efs_mount_target" "minecloud-frontend2-efs-target" {
  file_system_id = aws_efs_file_system.minecloud-fs.id
  subnet_id      = aws_subnet.minecloud-frontend2.id
}

resource "aws_efs_access_point" "minecloud-efs-ap" {
  file_system_id = aws_efs_file_system.minecloud-fs.id

  root_directory {
    path = "/data"
    creation_info {
      owner_gid = 1000
      owner_uid = 1000
      permissions = 0777
    }
  }

  posix_user {
    gid = 1000
    uid = 1000
  }
}
