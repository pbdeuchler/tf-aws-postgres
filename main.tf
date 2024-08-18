resource "aws_ebs_volume" "postgres" {
  availability_zone = var.ebs_az
  encrypted         = true
  type              = "gp3"
  size              = var.volume_size
  throughput        = var.volume_throughput

  tags = {
    Terraform   = "true"
    Environment = "prod"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-*-24.04-arm64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

locals {
  postgres_launch_name_prefix = "postgres-${var.env}-"
  security_groups_ids         = compact(concat(var.security_group_ids, aws_security_group.postgres.id))
}

resource "aws_launch_template" "postgres_launch_config" {
  name_prefix   = local.postgres_launch_name_prefix
  image_id      = var.ami_id == null ? data.aws_ami.ubuntu.id : var.ami_id
  instance_type = var.instance_type
  key_name      = var.ssh_key_id
  ebs_optimized = true
  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2-postgres.arn
  }

  user_data = base64encode(templatefile("${path.module}/templates/postgres_user_data.txt", {
    postgres_major_version    = 16
    postgres_listen_addresses = "*"
    ebs_volume_id             = aws_ebs_volume.postgres.id
    use_eip                   = var.use_eip ? "true" : ""
    install_timescale         = var.install_timescale ? "true" : ""
    eip_id                    = var.eip_id
  }))

  network_interfaces {
    associate_public_ip_address = var.use_eip ? true : false
    security_groups             = local.security_groups_ids
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      launch-template-name = local.postgres_launch_name_prefix
      project              = "postgres"
      env                  = var.env
      tf-managed           = "True"
    }
  }
}

resource "aws_autoscaling_group" "postgres_asg" {
  name                 = aws_launch_template.postgres_launch_config.name
  min_size             = var.asg_min_size
  desired_capacity     = var.asg_desired_capacity
  max_size             = var.asg_max_size
  vpc_zone_identifier  = var.subnet_ids
  health_check_type    = "EC2"
  termination_policies = ["OldestLaunchConfiguration", "OldestInstance"]
  target_group_arns    = var.target_group_arns

  launch_template {
    id      = aws_launch_template.postgres_launch_config.id
    version = "$Latest"
  }

}
