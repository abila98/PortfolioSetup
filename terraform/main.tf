provider "aws" {
  region = "us-west-1"  
}

# Create a new launch template
resource "aws_launch_template" "lt_1" {
  name_prefix   = "coffee-lt"
  image_id      = "ami-056894b012ac127fb"  
  instance_type = "t2.micro"       

}

