data "aws_ami" "amazon_linux_latest" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["*al2023-ami-2023*x86_64*"]
  }
  filter {
    name   = "platform-details"
    values = ["Linux/UNIX"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}