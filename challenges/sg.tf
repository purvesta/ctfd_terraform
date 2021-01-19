# Configure default security group
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.challenges.id

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

# Configure custom security group for challenges
resource "aws_security_group" "web-challenge-alb-sg" {
  name        = "web-challenge-alb-sg"
  description = "Controls access to the challenge cluster load balancers"
  vpc_id      = aws_vpc.challenges.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # cidr_blocks = ["0.0.0.0/0"]
    cidr_blocks = ["160.3.69.74/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web-challenge-sg" {
  name        = "web-challenge-sg"
  description = "Controls access to the challenge containers"
  vpc_id      = aws_vpc.challenges.id

  ingress {
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    # cidr_blocks = ["0.0.0.0/0"]
    cidr_blocks = ["160.3.69.74/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}