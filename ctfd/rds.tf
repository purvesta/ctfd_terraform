resource "aws_db_instance" "ctfd-db" {
  identifier_prefix      = "${var.service}-db-"
  allocated_storage      = 20
  max_allocated_storage  = 50
  storage_type           = "gp2"
  storage_encrypted      = true
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = var.service
  username               = var.dbuser
  password               = var.dbpass
  db_subnet_group_name   = aws_db_subnet_group.ctfd-db-subnet-group.name
  parameter_group_name   = "default.mysql5.7"
  vpc_security_group_ids = [aws_security_group.ctfd-db-sg.id]
}

resource "aws_db_subnet_group" "ctfd-db-subnet-group" {
  name       = "${var.service}-db-sg"
  subnet_ids = [
                aws_subnet.ctfd-subnet-1.id,
                aws_subnet.ctfd-subnet-2.id
               ]

  tags = {
    Name = "${var.service}-db-subg"
  }
}
