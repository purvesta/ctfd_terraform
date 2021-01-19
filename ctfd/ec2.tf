resource "aws_key_pair" "ansible" {
  key_name   = "ansible-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCv1RY/CkxErOyaHnCYxl+vZefNnZ/vwgAVb1DqKfSnECqiV+wBPDAHOL/VrJTmx5KxEEOyf2Q/QaklyCduGSv75qyXOWL257jkMZ08NJFVoqLyBiHGPXDHDlL55gsr7rF3/5KQvqdwi3CSoS6VR+Ax3g7Jm7jwDp55jaHDoYLEaqiKGM23QjdIU0OaDYjmDx2CCiVL1pQlBf44lv5Us0Vg3OAVvCQ20iVuB8QsdQ7HmZTeMtTucm3LZcjzzu0AyPtLDxrJzB+m69s3jXlFzXpjlua99uEjorBm1EiAFu/IDrF4g9ga60EcSQkdGh1kAqHTkH5zxSe+3zdvP7nBcmpDd8wyDebkpV7njURzkba07ew6c/77rlQjPyuLcbE/7QHpvVbgG1c41Vlbs40bwXRJ8cqPq4tPdty0pQk+sx+MdQx9DLsa5YgofeS0kKjusdxNOkA1DppbthsIeOOT38o+4NZHCvABng1jWSgXCmUur/MioUNcw/3rYoRggypr7Hxd/rR6rHSZv2qPX115OiDVwnQsSQYXsVsxDIeRBXPTkIcHI124RjZ1Fvny1PHqKIF9K/r3oLBqzaP/Rf/bIknPZltmIwi7fDtKpGtjUut1Cd63kx1HiJZQbX5s5huodbfOhrS18o9c3GssjiCvGKgl8PyXWJwnNIKmhuyB65HEvQ=="
}

resource "aws_launch_template" "ctfd-lt" {
  name_prefix            = "${var.service}-"
  image_id               = var.ctfd-ami
  instance_type          = var.ctfd-it
  key_name               = aws_key_pair.ansible.key_name
  user_data              = base64encode(data.template_file.script.rendered)
  depends_on             = [
    aws_efs_file_system.ctfd-fs,
    aws_security_group.ctfd-sg
  ]
  update_default_version = true

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = [aws_security_group.ctfd-sg.id]
  }

  tags = {
    Name = "${var.service}-lt"
  }
}

resource "aws_autoscaling_group" "ctfd-asg" {
  name                  = "ctfd-asg"
  desired_capacity      = 2
  max_size              = 3
  min_size              = 1
  health_check_type     = "EC2"
  # target_group_arns     = [aws_lb_target_group.ctfd-http-alb-tg.arn, aws_lb_target_group.ctfd-https-alb-tg.arn]
  target_group_arns     = [aws_lb_target_group.ctfd-http-alb-tg.arn]
  vpc_zone_identifier   = [
    aws_subnet.ctfd-subnet-1.id,
    aws_subnet.ctfd-subnet-2.id
  ]
  depends_on            = [
    aws_subnet.ctfd-subnet-1,
    aws_subnet.ctfd-subnet-2,
    aws_lb.ctfd-alb
  ]

  launch_template {
    id      = aws_launch_template.ctfd-lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.service}-asg-instance"
    propagate_at_launch = true
  }
}

resource "aws_instance" "awx" {
  ami                         = var.awx-ami
  instance_type               = var.awx-it
  subnet_id                   = aws_subnet.ctfd-subnet-1.id
  key_name                    = aws_key_pair.ansible.key_name
  associate_public_ip_address = true

  tags = {
    Name = "awx-instance"
  }
}

data "template_file" "script" {
  template = file("${path.module}/init/ctfd-init.sh")

  vars = {
    ctfd-fs-id = aws_efs_file_system.ctfd-fs.id
    region     = var.region
  }
}
