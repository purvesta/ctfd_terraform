#resource "aws_acm_certificate" "ctfd-cert" {
#  domain_name       = "ctf.neverlanctf.com"
#  validation_method = "DNS"
#
#  tags = {
#    Name = "${var.service}-cert"
#  }
#
#  lifecycle {
#    create_before_destroy = true
#  }
#}
