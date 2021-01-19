#variable "user" {
#  description = "Default aws instance username"
#  default     = "ubuntu"
#}

variable "service" {
  description = "The name of this service"
  default     = "challenges"
}

variable "challenges" {
  description = "A list of challenge names (must be the same as the challenge file names)"
  default     = ["cookie-monster", "sql-fun1", "js-pass"]
}

variable "container_port" {
  description = "The port for all containers to listen on"
  default     = 8000
}

variable "region" {
  description = "Default region for minecloud"
  default     = "us-west-2"
}

variable "vpc-cidr" {
  description = "CIDR for VPC"
  default     = "192.168.0.0/16"
}

variable "vpc-challenge-subnet-1-cidr" {
  description = "CIDR for VPC"
  default     = "192.168.3.0/24"
}

variable "vpc-challenge-subnet-2-cidr" {
  description = "CIDR for VPC"
  default     = "192.168.4.0/24"
}
