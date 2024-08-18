resource "aws_iam_role" "ec2-postgres" {
  name = "postgres-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_policy" "postgres-ebs-bootstrap" {
  name        = "postgres-ebs-boostrap"
  description = "policy to allow postgres ec2 instances to mount ebs volumes"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ec2:AttachVolume",
        "ec2:DetachVolume",
      ]
      Resource = [
        aws_ebs_volume.postgres.arn,
        "arn:aws:ec2:*:*:instance/*"
      ]
      },
      {
        "Effect" : "Allow",
        "Action" : "ec2:DescribeVolumes",
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_policy" "postgres-eip-bootstrap" {
  name        = "postgres-eip-boostrap"
  description = "policy to allow postgres ec2 instances to associate eip addresses"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ec2:AssociateAddress",
      ]
      Resource = ["*"] 
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2-postgres-ebs-binding" {
  role       = aws_iam_role.ec2-postgres.name
  policy_arn = aws_iam_policy.postgres-ebs-bootstrap.arn
}

resource "aws_iam_role_policy_attachment" "ec2-postgres-eip-binding" {
  role       = aws_iam_role.ec2-postgres.name
  policy_arn = aws_iam_policy.postgres-eip-bootstrap.arn
}

resource "aws_iam_role_policy_attachment" "ec2-postgres-cloudwatch-binding" {
  role       = aws_iam_role.ec2-postgres.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "ec2-postgres" {
  name = "postgres-profile"
  role = aws_iam_role.ec2-postgres.name
}
