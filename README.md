# tf-aws-postgres

A Terraform module to deploy a PostgreSQL server using an AWS autoscaling group. Not thoroughly tested, use at your own risk. EIP functionality will probably never be tested by me.

Note: Currently the first instance setup will partially fail since the EBS volume will not be formatted

| Variable Name          | Type         | Default      | Description                                                                                                                              |
| ---------------------- | ------------ | ------------ | ---------------------------------------------------------------------------------------------------------------------------------------- |
| `ssh_key_id`           | string       | -            | A SSH public key ID to add to the VPN instance.                                                                                          |
| `instance_type`        | string       | `"t2.micro"` | The machine type to launch, some machines may offer higher throughput for higher use cases.                                              |
| `volume_size`          | number       | 10           | The size of the EBS volume to attach to the Postgres server.                                                                             |
| `volume_throughput`    | number       | 250          | The throughput of the EBS volume to attach to the Postgres server.                                                                       |
| `asg_min_size`         | number       | 1            | Minimum size of the Auto Scaling Group. You probably don't want to change this.                                                          |
| `asg_desired_capacity` | number       | 1            | Desired capacity of the Auto Scaling Group. You probably don't want to change this.                                                      |
| `asg_max_size`         | number       | 1            | Maximum size of the Auto Scaling Group. You probably don't want to change this.                                                          |
| `vpc_id`               | string       | -            | The VPC ID in which Terraform will launch the resources.                                                                                 |
| `subnet_ids`           | list(string) | -            | A list of subnets for the Autoscaling Group to use for launching instances. May be a single subnet, but it must be an element in a list. |
| `allowed_cidr_blocks`  | list(string) | -            | A list of CIDR blocks to allow access to the Postgres server.                                                                            |
| `ebs_az`               | string       | -            | AZ to provision EBS volume in.                                                                                                           |
| `use_eip`              | bool         | `false`      | Please don't make your database publicly accessible                                                                                      |
| `eip_id`               | string       | `"changeme"` | ID of the Elastic IP to use, when use_eip is enabled.                                                                                    |
| `security_group_ids`   | list(string) | `[""]`       | Additional security group IDs to attach to the Postgres server.                                                                          |
| `target_group_arns`    | list(string) | `null`       | Running a scaling group behind an LB requires this variable, default null means it won't be included if not set.                         |
| `env`                  | string       | `"prod"`     | The name of environment. Used to differentiate multiple deployments.                                                                     |
| `ami_id`               | string       | `null`       | The AWS AMI to use for the postgres server, defaults to the latest Ubuntu 24.04 AMI if not specified.                                    |
| `install_timescale`    | bool         | `false`      | Whether to install TimescaleDB on the Postgres server.                                                                                   |
