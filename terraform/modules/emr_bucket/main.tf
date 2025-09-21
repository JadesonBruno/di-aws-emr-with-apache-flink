# Caller Identity to get the AWS Account ID
data "aws_caller_identity" "current" {}


# S3 Bucket for EMR Logs
resource "aws_s3_bucket" "emr_bucket" {
    bucket = "${var.project_name}-${var.environment}-emr-bucket-${data.aws_caller_identity.current.account_id}"
    force_destroy = true

    tags = {
        Name = "${var.project_name}-${var.environment}-emr-bucket"
        Project = var.project_name
        Environment = var.environment   
        Service = "EMR"
        Terraform = "true"
  }
}


# Block Public Access to the S3 Bucket
resource "aws_s3_bucket_public_access_block" "emr_bucket_block" {
    bucket = aws_s3_bucket.emr_bucket.id

    block_public_acls = true
    ignore_public_acls = true
    block_public_policy = true
    restrict_public_buckets = true
}


# Enable Versioning on the S3 Bucket
resource "aws_s3_bucket_versioning" "emr_bucket_versioning" {
    bucket = aws_s3_bucket.emr_bucket.id

    versioning_configuration {
        status = "Enabled"
    }
}


resource "aws_s3_object" "data" {
    bucket = aws_s3_bucket.emr_bucket.id
    key    = "data/words.txt"
    source = "${path.module}/data/inputs/words.txt"
    content_type = "text/plain"
}
