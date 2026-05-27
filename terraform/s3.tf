resource "aws_s3_bucket" "cloud_portfolio_bucket" {
  bucket = var.s3_portfolio_bucket
}

resource "aws_s3_bucket_public_access_block" "cloud_portfolio_public_access_block" {
  bucket = aws_s3_bucket.cloud_portfolio_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

