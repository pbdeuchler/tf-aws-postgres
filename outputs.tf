output "postgres_iam_role_name" {
  value       = aws_iam_role.postgres.name
  description = "Name of the IAM role provisioned to Postgres instances"
}

output "postgres_security_group_id" {
  value       = aws_security_group.postgres.id
  description = "ID of the security group provisioned to Postgres instances"
}
