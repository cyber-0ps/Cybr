# Get current region
data "aws_region" "current" {}

# get current account ID
data "aws_caller_identity" "current" {}

# create IAM role for SSM
resource "aws_iam_role" "default_host_management" {
    name = "AWSSystemsManagerDefaultEC2InstanceManagementRole"
    description = "AWS Systems Manager Default EC2 Instance Management Role"
    assume_role_policy = jsonencode(
        {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ssm.amazonaws.com"
          }
        },
      ]
      Version = "2012-10-17"
    }
    )
}