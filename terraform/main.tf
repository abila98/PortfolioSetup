module "backend" {
  source = "./backend"
}

module "vpc" {
  source = "./vpc"
}

module "asg" {
  source             = "./asg"
  vpc_id             = module.vpc.vpc_id
  security_group_id  = module.vpc.security_group_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
}
 
