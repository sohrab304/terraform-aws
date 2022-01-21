module "vpc" {
  source                    = "../vpc-module"
  vpc_cidr_block            = var.vpc_cidr_block
  vpc_tag_name              = var.vpc_tag_name
  public_subnet_cidr_block  = var.public_subnet_cidr_block
  public_subnet_tag_name    = var.public_subnet_tag_name
  private_subnet_cidr_block = var.private_subnet_cidr_block
  private_subnet_tag_name   = var.private_subnet_tag_name
}


module "ec2" {
  source                 = "../ec2-module"
  public_subnet_tag_name = var.public_subnet_tag_name
  depends_on             = [module.vpc]
}


