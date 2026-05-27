resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "cloud_portfolio_oac"
  description                       = "OAC for Cloud Portfolio Website"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "portfolio_cdn" {
  origin {
    domain_name              = aws_s3_bucket.cloud_portfolio_bucket.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.cloud_portfolio_bucket.id
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
  }
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.cloud_portfolio_bucket.id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

data "aws_iam_policy_document" "s3_portfolio_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.cloud_portfolio_bucket.arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.portfolio_cdn.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "cloud_portfolio_bucket_policy" {
  bucket = aws_s3_bucket.cloud_portfolio_bucket.id
  policy = data.aws_iam_policy_document.s3_portfolio_policy.json
}
