// Custom VPC
resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = var.aws_tagging
}