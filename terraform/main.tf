
module "vpc" {
  source = "./vpc"
  ami_id = var.ami_id
}

module "asg" {
  source             = "./asg"
  vpc_id             = module.vpc.vpc_id
  ami_id             = var.ami_id
  security_group_id  = module.vpc.security_group_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
}


module "cloudwatch" {
  source            = "./cloudwatch"
  load_balancer_arn = module.asg.load_balancer_arn
}

