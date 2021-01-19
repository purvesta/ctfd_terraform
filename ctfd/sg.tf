# Configure default security group
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.ctf-interface.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ctfd-alb-sg" {
  name        = "${var.service}-alb-sg"
  description = "Controls access to ctfd"
  vpc_id      = aws_vpc.ctf-interface.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound traffic from any port to any port allowed
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.service}-alb-sg"
  }
}

resource "aws_security_group" "ctfd-sg" {
  name        = "${var.service}-sg"
  description = "Controls access to ctfd"
  vpc_id      = aws_vpc.ctf-interface.id

  ingress {
    security_groups = [aws_security_group.ctfd-alb-sg.id]
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound traffic from any port to any port allowed
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.service}-sg"
  }
}

resource "aws_security_group" "ctfd-db-sg" {
  name        = "${var.service}-db-sg"
  description = "Controls access to ctfd database"
  vpc_id      = aws_vpc.ctf-interface.id

  ingress {
    security_groups = [aws_security_group.ctfd-sg.id]
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
  }

  egress {
    security_groups = [aws_security_group.ctfd-sg.id]
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
  }

  tags = {
    Name = "${var.service}-db-sg"
  }
}
