variable "ssh_key_id" {
  description = "A SSH public key ID to add to the VPN instance."
}

variable "instance_type" {
  default     = "t2.micro"
  description = "The machine type to launch, some machines may offer higher throughput for higher use cases."
}

variable "volume_size" {
  default     = 10
  description = "The size of the EBS volume to attach to the Postgres server."
}

variable "volume_throughput" {
  default     = 250
  description = "The throughput of the EBS volume to attach to the Postgres server."
}

variable "asg_min_size" {
  default     = 1
  description = "You probably don't want to change this."
}

variable "asg_desired_capacity" {
  default     = 1
  description = "You probably don't want to change this."
}

variable "asg_max_size" {
  default     = 1
  description = "You probably don't want to change this."
}

variable "vpc_id" {
  description = "The VPC ID in which Terraform will launch the resources."
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnets for the Autoscaling Group to use for launching instances. May be a single subnet, but it must be an element in a list."
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "A list of CIDR blocks to allow access to the Postgres server."
}

variable "ebs_az" {
  type        = string
  description = "AZ to provision EBS volume in."
}

variable "use_eip" {
  type        = bool
  default     = false
  description = "Please don't make your database publicly accessible"
}

variable "eip_id" {
  type        = string
  default     = "changeme"
  description = "ID of the Elastic IP to use, when use_eip is enabled."
}

variable "security_group_ids" {
  type        = list(string)
  default     = [""]
  description = "Additional security group IDs to attach to the Postgres server."
}

variable "target_group_arns" {
  type        = list(string)
  default     = null
  description = "Running a scaling group behind an LB requires this variable, default null means it won't be included if not set."
}

variable "env" {
  default     = "prod"
  description = "The name of environment. Used to differentiate multiple deployments."
}

variable "ami_id" {
  default     = null # we check for this and use a data provider since we can't use it here
  description = "The AWS AMI to use for the postgres server, defaults to the latest Ubuntu 24.04 AMI if not specified."
}

variable "install_timescale" {
  default     = false
  description = "Whether to install TimescaleDB on the Postgres server."
}
