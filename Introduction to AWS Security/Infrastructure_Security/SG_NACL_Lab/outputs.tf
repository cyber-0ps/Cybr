output "vpc_id" {
  value = aws_vpc.main.id
}

output "web_sg_id" {
  value = aws_security_group.web_servers.id
}