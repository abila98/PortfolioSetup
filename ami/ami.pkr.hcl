packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
   ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }
  }
}


variable "region" {
  type    = string
  default = "us-west-1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami_id" {
  type    = string
  default = "ami-0a2781a262879e465"
}

variable "owner_acc_id" {
  type    = string
  default = "137112412989"
}

variable "tag_version" {
  type    = string
  default = "user `tag_version`"
}

variable "ansible_vault_password" {
  type    = string
  default = ""
}

source "amazon-ebs" "example" {
  region          = var.region
  instance_type   = var.instance_type
  ami_name        = "portfolio-${var.tag_version}"
  source_ami_filter {
    filters = {
      root-device-type = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = [var.owner_acc_id]
  }
  ssh_username    = "ec2-user"
  ssh_agent_auth  = false
  ami_regions     = [var.region]
}

build {
  sources = ["source.amazon-ebs.example"]

  provisioner "ansible" {
    user = "ec2-user"
    playbook_file   = "ami/ansible/deploy.yml"
    extra_arguments = ["--vault-password-file=vault_password_file"]
  }
}

