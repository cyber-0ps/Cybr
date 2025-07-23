# Get current region
data "aws_region" "current" {}

# get current account ID
data "aws_caller_identity" "current" {}

