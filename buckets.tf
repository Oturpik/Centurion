# User Upload Bucket
resource "aws_s3_bucket" "user_upload_bucket" {
  bucket = "user-upload-bucket"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "User Upload Bucket"
    Environment = "Production"
  }
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
    Version: "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Principal: "*",
        Action: "s3:PutObject",
        Resource: "${aws_s3_bucket.user_upload_bucket.arn}/*",
        Condition: {
          Bool: {
            "aws:SecureTransport": "true"
          },
          StringEquals: {
            "s3:x-amz-server-side-encryption": "AES256"
          }
        }
      },
      {
        Effect: "Allow",
        Principal: "*",
        Action: "s3:GetObject",
        Resource: "${aws_s3_bucket.user_upload_bucket.arn}/*",
        Condition: {
          Bool: {
            "aws:SecureTransport": "true"
          }
        }
      }
    ]
  })
}

# Processed Images Bucket
resource "aws_s3_bucket" "processed_images_bucket" {
  bucket = "processed-images-bucket"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "Processed Images Bucket"
    Environment = "Production"
  }
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
    Version: "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Principal: "*",
        Action: "s3:GetObject",
        Resource: "${aws_s3_bucket.processed_images_bucket.arn}/*",
        Condition: {
          Bool: {
            "aws:SecureTransport": "true"
          }
        }
      }
    ]
  })
}
