# # IAM Role for Terraform
# resource "aws_iam_role" "terraform_role" {
#   name = "TerraformRole"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         },
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }

# # IAM Policy for the Role
# resource "aws_iam_policy" "terraform_policy" {
#   name        = "TerraformPolicy"
#   description = "Policy to allow Terraform to manage resources"
  
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Action = "*",
#         Resource = "*"
#       }
#     ]
#   })
# }

# # Attach the Policy to the Role
# resource "aws_iam_role_policy_attachment" "terraform_role_policy_attachment" {
#   role       = aws_iam_role.terraform_role.name
#   policy_arn = aws_iam_policy.terraform_policy.arn
# }

# # Configure the AWS provider to assume the created role
# provider "aws" {
#   region = "us-west-2"

#   assume_role {
#     role_arn = aws_iam_role.terraform_role.arn
#   }
# }
