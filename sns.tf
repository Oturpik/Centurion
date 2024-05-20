# SNS Topic for Image Processing Notifications
resource "aws_sns_topic" "image_processing_notifications" {
  name = "image-processing-notifications"

  tags = {
    Name        = "Image Processing Notifications"
    Environment = "Production"
  }
}

# Optional: SNS Topic Subscription (for email notifications)
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.image_processing_notifications.arn
  protocol  = "email"
  endpoint  = "your-email@example.com" # replace with the actual email address
}
