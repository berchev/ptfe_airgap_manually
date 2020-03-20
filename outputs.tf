######################## Outputs ##########################
output "ptfe_instance_public_ip" {
  value       = aws_instance.ptfe_instance.public_ip
  description = "Public IP address of the PTFE instance"
}

output "ptfe_instance_public_dns" {
  value       = aws_instance.ptfe_instance.public_dns
  description = "Public DNS address of the PTFE instance"
}

output "ptfe_instance_private_ip" {
  value       = aws_instance.ptfe_instance.private_ip
  description = "Private IP address of the PTFE instance"
}

output "ptfe_instance_private_dns" {
  value       = aws_instance.ptfe_instance.private_dns
  description = "Private DNS address of the PTFE instance"
}

output "postgres_name" {
  value       = aws_db_instance.postgres.name
  description = "Postgres name"
}

output "postgres_hostname" {
  value       = aws_db_instance.postgres.endpoint
  description = "Postgres hostname"
}