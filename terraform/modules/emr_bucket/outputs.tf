# EMR Bucket Name
output "emr_bucket_name" {
    description = "The name of the S3 bucket for EMR"
    value = aws_s3_bucket.emr_bucket.bucket
}
