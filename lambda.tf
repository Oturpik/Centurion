resource "aws_lambda_function" "image_processing_lambda" {
  filename         = "lambda.zip"
  function_name    = "image_processing_lambda"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  source_code_hash = filebase64sha256("lambda.zip")

  environment {
    variables = {
      PROCESSED_BUCKET = aws_s3_bucket.processed_images_bucket.bucket
      SNS_TOPIC_ARN    = aws_sns_topic.image_processing_notifications.arn
    }
  }

  tags = {
    Name        = "Image Processing Lambda"
    Environment = "Production"
  }
}

resource "aws_lambda_permission" "allow_s3_to_invoke" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_processing_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.user_upload_bucket.arn
}

resource "aws_s3_bucket_notification" "user_upload_bucket_notification" {
  bucket = aws_s3_bucket.user_upload_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_processing_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }
}
