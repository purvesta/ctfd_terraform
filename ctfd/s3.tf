############
# Build S3 #
############

resource "aws_s3_bucket" "ctfd-access" {
  bucket_prefix = "nlan-ctfd-access-"
  force_destroy = true

  tags = {
    name = "${var.service}-s3-access-logs"
  }
}

resource "aws_s3_bucket" "ctfd-uploads" {
  bucket_prefix = "nlan-ctfd-uploads-"
  force_destroy = true

  tags = {
    name = "${var.service}-s3-uploads"
  }
}

resource "aws_s3_bucket_policy" "ctfd-bucket-policy" {
  bucket = aws_s3_bucket.ctfd-access.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "${var.service}-ACCESSPOLICY",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.elb-account-id}:root"
      },
      "Action": "s3:PutObject",
      "Resource": "${aws_s3_bucket.ctfd-access.arn}/*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "${aws_s3_bucket.ctfd-access.arn}/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "${aws_s3_bucket.ctfd-access.arn}"
    }
  ]
}
POLICY
}
