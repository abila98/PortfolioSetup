# Get latest portfolio ami

data "aws_ami" "latest_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["portfolio-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["730335274738"] 
}
