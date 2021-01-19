################
# Default Vars #
################

variable "region" {
  description = "Default region"
  default = "us-west-2"
}

variable "az1" {
  description = "Default availability zone 1"
  default = "a"
}

variable "az2" {
  description = "Default availability zone 2"
  default = "b"
}

variable "service" {
  description = "Default name of service"
  default = "ctfd"
}

variable "vpc-cidr" {
  description = "Default vpc cidr"
  default     = "192.168.0.0/16"
}

variable "ctfd-subnet-1-cidr" {
  description = "Default subnet 1 cidr"
  default     = "192.168.1.0/24"
}

variable "ctfd-subnet-2-cidr" {
  description = "Default subnet 2 cidr"
  default     = "192.168.2.0/24"
}

variable "ctfd-it" {
  description = "Default ctfd instance type"
  default     = "t2.micro"
}

variable "ctfd-ami" {
  description = "Default ami for ctfd"
  default     = "ami-01ce4793a2f45922e"
}

variable "awx-it" {
  description = "Default ctfd instance type"
  default     = "t2.medium"
}

variable "awx-ami" {
  description = "Default ami for ctfd"
  default     = "ami-01ce4793a2f45922e"
}

variable "elb-account-id" {
  description = "Default elb account id for root in us-west-2"
  default     = "797873946194"
}

variable "dbuser" {
  description = "Default database user for rds instance"
  default     = "ctfd"
}

variable "dbpass" {
  description = "Default database password for rds instance"
  default     = "hackallthethings"
}
