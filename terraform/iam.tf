#IAM to read SSM Parameters

# Create IAM Role
resource "aws_iam_role" "ec2_s3_role" {
  name = "${var.tag_name}-ec2-s3-role"

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
    Name = "${var.tag_name}-ec2-s3-role"
  }
}

# Attach Policy to IAM Role
resource "aws_iam_role_policy" "s3_read_policy" {
  name = "${var.tag_name}-s3-read-policy"
  role = aws_iam_role.ec2_s3_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject"
        ]
        Resource = "*"
      }
    ]
  })
}

# Create IAM Instance Profile
resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.tag_name}-instance-profile"
  role = aws_iam_role.ec2_s3_role.name

  tags = {
    Name = "${var.tag_name}-instance-profile"
  }
}

