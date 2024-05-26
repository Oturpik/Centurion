import json
import boto3
import os
from PIL import Image
import io

s3_client = boto3.client('s3')
sns_client = boto3.client('sns')

def lambda_handler(event, context):
    # Get the S3 bucket and object key from the event
    record = event['Records'][0]
    source_bucket = record['s3']['bucket']['name']
    key = record['s3']['object']['key']
    
    # Define the processed bucket and SNS topic ARN
    processed_bucket = os.environ['PROCESSED_BUCKET']
    sns_topic_arn = os.environ['SNS_TOPIC_ARN']
    
    try:
        # Download the image from S3
        response = s3_client.get_object(Bucket=source_bucket, Key=key)
        image_data = response['Body'].read()
        
        # Resize the image
        image = Image.open(io.BytesIO(image_data)).resize((800, 600), Image.LANCZOS)
        
        # Save the image to a bytes buffer
        buffer = io.BytesIO()
        image.save(buffer, format="JPEG")
        buffer.seek(0)
        
        # Upload the processed image to the processed bucket
        processed_key = f"processed-{key}"
        s3_client.put_object(Bucket=processed_bucket, Key=processed_key, Body=buffer)
        
        # Generate the public URL
        public_url = f"https://{processed_bucket}.s3.amazonaws.com/{processed_key}"
        
        # Publish a notification to SNS
        message = f"Image {key} processed and stored as {processed_key}. Check it out here: {public_url}"
        sns_client.publish(TopicArn=sns_topic_arn, Message=message)
        
        return {
            'statusCode': 200,
            'body': f"Processed image {processed_key} and sent notification."
        }
    
    except Exception as e:
        return {
            'statusCode': 500,
            'body': f"Error processing image: {str(e)}"
        }
