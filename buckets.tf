variable "terraform_role_arn" {
  description = "The ARN of the IAM role to assume for Terraform"
  type        = string
}

provider "aws" {
  region = "us-west-2"

  assume_role {
    role_arn = var.terraform_role_arn
  }
}

# User Upload Bucket
resource "aws_s3_bucket" "user_upload_bucket" {
  bucket = "zilebado"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "User Upload Bucket"
    Environment = "Production"
  }
}

# Public Access Block for User Upload Bucket
resource "aws_s3_bucket_public_access_block" "user_upload_bucket_public_access" {
  bucket                  = aws_s3_bucket.user_upload_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Versioning configuration for User Upload Bucket
resource "aws_s3_bucket_versioning" "user_upload_bucket_versioning" {
  bucket = aws_s3_bucket.user_upload_bucket.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

# Server-Side Encryption configuration for User Upload Bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "user_upload_bucket_sse" {
  bucket = aws_s3_bucket.user_upload_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Intelligent-Tiering configuration for User Upload Bucket
resource "aws_s3_bucket_lifecycle_configuration" "user_upload_bucket_lifecycle" {
  bucket = aws_s3_bucket.user_upload_bucket.id

  rule {
    id     = "Move to Intelligent-Tiering"
    status = "Enabled"

    transition {
      days          = 0
      storage_class = "INTELLIGENT_TIERING"
    }
  }
}

# Bucket Policy for User Upload Bucket to allow uploads from presigned URLs
resource "aws_s3_bucket_policy" "user_upload_bucket_policy" {
  bucket = aws_s3_bucket.user_upload_bucket.id

  policy = jsonencode({
        "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::zilebado/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-server-side-encryption": "AES256"
                },
                "Bool": {
                    "aws:SecureTransport": "true"
                }
            }
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::035431961317:role/lambda_s3_sns_role"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::zilebado/*"
        },
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::zilebado/*",
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "true"
                }
            }
        }
    ]

  })
}

# Processed Images Bucket
resource "aws_s3_bucket" "processed_images_bucket" {
  bucket = "zilecompleted"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "Processed Images Bucket"
    Environment = "Production"
  }
}

# Public Access Block for Processed Images Bucket
resource "aws_s3_bucket_public_access_block" "processed_images_bucket_public_access" {
  bucket                  = aws_s3_bucket.processed_images_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Versioning configuration for Processed Images Bucket
resource "aws_s3_bucket_versioning" "processed_images_bucket_versioning" {
  bucket = aws_s3_bucket.processed_images_bucket.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

# Server-Side Encryption configuration for Processed Images Bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "processed_images_bucket_sse" {
  bucket = aws_s3_bucket.processed_images_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Intelligent-Tiering configuration for Processed Images Bucket
resource "aws_s3_bucket_lifecycle_configuration" "processed_images_bucket_lifecycle" {
  bucket = aws_s3_bucket.processed_images_bucket.id

  rule {
    id     = "Move to Intelligent-Tiering"
    status = "Enabled"

    transition {
      days          = 0
      storage_class = "INTELLIGENT_TIERING"
    }
  }
}

# Bucket Policy for Processed Images Bucket to limit public access
resource "aws_s3_bucket_policy" "processed_images_bucket_policy" {
  bucket = aws_s3_bucket.processed_images_bucket.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::zilecompleted/*",
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "true"
                }
            }
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::035431961317:role/lambda_s3_sns_role"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::zilecompleted/*"
        }
    ]
}
)
}
