############
# Build S3 #
############

resource "aws_s3_bucket" "minecloud-bucket" {
  bucket = "krs-minecloud-bucket"
}

#resource "aws_s3_bucket_policy" "minecloud-bucket-policy" {
#  bucket = aws_s3_bucket.minecloud-bucket.id
#
#  policy = <<POLICY
#{
#  "Version": "2012-10-17",
#  "Id": "CraftBucketPolicy",
#  "Statement": [
#    {
#      "Sid": "IPAllow",
#      "Effect": "Deny",
#      "Principal": "*",
#      "Action": "s3:*",
#      "Resource": "arn:aws:s3:::minecloud-bucket/*",
#      "Condition": {
#         "IpAddress": {"aws:SourceIp": "8.8.8.8/32"}
#      }
#    }
#  ]
#}
#POLICY
#}
