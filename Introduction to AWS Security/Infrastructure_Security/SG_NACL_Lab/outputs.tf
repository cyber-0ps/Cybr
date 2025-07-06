output "vpc_id" {
  value = aws_vpc.main.id
}

output "web_sg_id" {
  value = aws_security_group.web_servers.id
}

output "app_sg_id" {
  value = aws_security_group.app_servers.id
}

output "it_admin_sg_id" {
  value = aws_security_group.it_admin
}

output "database_sg_id" {
  value = aws_security_group.database.id
}