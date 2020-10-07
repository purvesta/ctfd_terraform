resource "aws_efs_file_system" "ctfd-fs" {
  creation_token = "ctfd-fs"
  encrypted      = "true"

  tags = {
    Name = "${var.service}-fs"
  }
}

resource "aws_efs_mount_target" "ctfd-subnet-1-efs-target" {
  file_system_id = aws_efs_file_system.ctfd-fs.id
  subnet_id      = aws_subnet.ctfd-subnet-1.id
}

resource "aws_efs_mount_target" "ctfd-subnet-2-efs-target" {
  file_system_id = aws_efs_file_system.ctfd-fs.id
  subnet_id      = aws_subnet.ctfd-subnet-2.id
}

resource "aws_efs_access_point" "ctfd-efs-ap" {
  file_system_id = aws_efs_file_system.ctfd-fs.id

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

  tags = {
    Name = "${var.service}-efs-ap"
  }
}
