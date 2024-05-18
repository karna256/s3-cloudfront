data "aws_s3_bucket" "this" {
  bucket = var.bucket_id
}

resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name = data.aws_s3_bucket.this.bucket_domain_name
    origin_id   = data.aws_s3_bucket.this.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Managed by Terraform"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = data.aws_s3_bucket.this.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  price_class = "PriceClass_100"

  tags = {
    Name = "ankit-s3-cloudfront-distribution"
  }
}

resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "Managed by Terraform"
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.this.iam_arn]
    }
    resources = [
      data.aws_s3_bucket.this.arn,
      "${data.aws_s3_bucket.this.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = data.aws_s3_bucket.this.bucket
  policy = data.aws_iam_policy_document.this.json
}