# AWS region to deploy infrastructure
variable "aws_region" {
  description = "The AWS region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "it_admin_ips" {
    description = "List of CIDR blocks for IT admin access"
    type = list(string)
    default = [ "172.16.0.0/16", "192.168.0.0/16" ]
}

variable "web_sg_name" {
  default = "web-server"
}

variable "app_sg_name" {
  default = "app-servers"
}

variable "it_sg_name" {
  default = "it-administrator"
}

variable "db_sg_name" {
  default = "database"
}