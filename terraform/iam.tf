#IAM to read SSM Parameters

# Create IAM Role
resource "aws_iam_role" "ec2_sec_role" {
  name = "${var.tag_name}-ec2-sec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${var.tag_name}-ec2-sec-role"
  }
}

# Attach Policy to IAM Role
resource "aws_iam_role_policy" "sec_read_policy" {
  name = "${var.tag_name}-sec-read-policy"
  role = aws_iam_role.ec2_sec_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:*"
        ]
        Resource = "*"
      }
    ]
  })
}

# Create IAM Instance Profile
resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.tag_name}-instance-profile"
  role = aws_iam_role.ec2_sec_role.name

  tags = {
    Name = "${var.tag_name}-instance-profile"
  }
}

