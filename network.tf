resource "aws_security_group" "postgres" {
  name        = "security group for postgres instance"
  description = "Allows 5432 traffic from the private subnets and home connectivity"
  vpc_id      = var.vpc_id

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "postgres-vpc-ingress" {
  description       = "Postgres from VPC"
  type              = "ingress"
  security_group_id = aws_security_group.postgres.id
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
}
