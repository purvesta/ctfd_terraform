output "db_instance_endpoint" {
  value = aws_db_instance.ctfd-db.endpoint
}

output "s3_endpoint" {
  value = aws_s3_bucket.ctfd-uploads.bucket_domain_name
}
