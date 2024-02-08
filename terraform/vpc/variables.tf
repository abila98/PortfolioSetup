variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for public subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks for private subnets"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "ami_id" {
  description = "ID of the AMI to use for instances"
  default     = "ami-0b4256158dfc602f6"
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the key pair to use for SSH access"
  default     = "aws-key"
}

variable "security_group_ingress_port" {
  description = "Port for security group ingress rules"
  default     = 8080
}

variable "availability_zone_1" {
  description = "Availability zone for resource deployment"
  default     = "us-west-1b"
}

variable "availability_zone_2" {
  description = "Availability zone for resource deployment"
  default     = "us-west-1c"
}

variable "tag_name" {
  description = "Name tag for resources"
  default     = "portfolio"
}

