############
# Defaults #
############

variable "region" {
  description = "AWS region to use"
  default     = "us-west-1"
}

variable "az1" {
  description = "AWS availability zone 1 to use"
  default     = "b"
}

variable "az2" {
  description = "AWS availability zone 2 to use"
  default     = "c"
}

variable "ctfd-ami" {
  description = "AMI to use for ctfd instances"
  default     = "ami-0e4035ae3f70c400f"
}
