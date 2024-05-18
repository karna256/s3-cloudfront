module "s3_bucket" {
  source = "../../common/s3"
  bucket_name = "ankit-training-s3-bucket-dev"
}

module "distribution" {
  source = "../../common/cloudfront"
    bucket_id = module.s3_bucket.s3_bucket_id
}

