module "network" {
  source             = "../../modules/network"
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
}

module "role" {
  source              = "../../modules/role"
  environment         = var.environment
  ansible_bucket_name = var.ansible_bucket_name
  ssm_role            = var.ssm_role
}

module "security" {
  source      = "../../modules/security"
  environment = var.environment
  vpc_id      = module.network.vpc_id
}

module "compute" {
  source               = "../../modules/compute"
  instance_type        = var.instance_type
  environment          = var.environment
  public_subnet_id     = module.network.subnet_id
  iam_instance_profile = module.role.instance_profile_name
  security_group_id    = module.security.security_group_id
}
