# AWS region to deploy the infrastructure
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type = string
  default = "us-east-1"
}