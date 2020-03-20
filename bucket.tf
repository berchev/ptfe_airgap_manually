

resource "aws_s3_bucket" "ptfe_bucket" {
  bucket = var.bucket_name

  tags = {
    Name = "PTFE bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "ptfe_bucket_permissions" {
  bucket = aws_s3_bucket.ptfe_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}