variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "security_group_id" {
  description = "The ID of the security group"
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]

}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]

}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
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

variable "tag_name" {
  description = "Name tag for resources"
  default     = "portfolio"
}

#variable "load_balancer_arn" {
#  description = "LB arn:"
#}
