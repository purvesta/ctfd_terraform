#variable "user" {
#  description = "Default aws instance username"
#  default     = "ubuntu"
#}

variable "db-user" {
  description = "Default DB instance username"
  default     = "tpurves"
}

variable "db-pass" {
  description = "Default DB instance password"
  default     = "cloudcraftallthethings"
}

variable "region" {
  description = "Default region for minecloud"
  default     = "us-west-2"
}

variable "vpc-cidr" {
  description = "CIDR for VPC"
  default     = "192.168.0.0/16"
}

variable "vpc-minecloud-db-subnet-cidr" {
  description = "CIDR for VPC"
  default     = "192.168.5.0/24"
}

variable "vpc-minecloud-db2-subnet-cidr" {
  description = "CIDR for VPC"
  default     = "192.168.6.0/24"
}

variable "vpc-minecloud-redis-subnet-cidr" {
  description = "CIDR for VPC"
  default     = "192.168.7.0/24"
}

variable "vpc-minecloud-redis2-subnet-cidr" {
  description = "CIDR for VPC"
  default     = "192.168.8.0/24"
}

variable "vpc-minecloud-frontend-subnet-cidr" {
  description = "CIDR for VPC"
  default     = "192.168.3.0/24"
}

variable "vpc-minecloud-frontend2-subnet-cidr" {
  description = "CIDR for VPC"
  default     = "192.168.4.0/24"
}
