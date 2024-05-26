# IAM Role and Policy for Lambda Function
resource "aws_iam_role_policy" "lambda_role_policy" {
  name   = "lambda_s3_sns_policy"
  role   = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Action: [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Resource: [
          "${aws_s3_bucket.user_upload_bucket.arn}",
          "${aws_s3_bucket.user_upload_bucket.arn}/*",
          "${aws_s3_bucket.processed_images_bucket.arn}",
          "${aws_s3_bucket.processed_images_bucket.arn}/*"
        ]
      },
      {
        Effect: "Allow",
        Action: "sns:Publish",
        Resource: aws_sns_topic.image_processing_notifications.arn
      }
    ]
  })
}

# IAM Role for Lambda Function
resource "aws_iam_role" "lambda_role" {
  name = "lambda_s3_sns_role"

  assume_role_policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Principal: {
          Service: "lambda.amazonaws.com"
        },
        Action: "sts:AssumeRole"
        "Action": [
				"s3:GetObject",
				"s3:PutObject",
				"s3:ListBucket",
				"s3:PutObjectAcl"
			],
			"Effect": "Allow",
			"Resource": [
				"arn:aws:s3:::zilebado",
				"arn:aws:s3:::zilebado/*",
				"arn:aws:s3:::zilecompleted",
				"arn:aws:s3:::zilecompleted/*"
			],
      },
		{
			"Action": "sns:Publish",
			"Effect": "Allow",
			"Resource": "arn:aws:sns:us-west-2:035431961317:image-processing-notifications"
		}
    ]
  })
}