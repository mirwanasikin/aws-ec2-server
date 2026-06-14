module "network" {
  source                 = "../../modules/network"
  environment            = var.environment
  vpc_cidr               = var.vpc_cidr
  public_subnets         = var.public_subnets
  private_subnets        = var.private_subnets
  nat_gateway_subnet_key = var.nat_gateway_subnet_key
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
  vpc_cidr    = var.vpc_cidr
}

module "compute" {
  source               = "../../modules/compute"
  instances            = var.instances
  environment          = var.environment
  private_subnet_id    = module.network.private_subnet_ids
  iam_instance_profile = module.role.instance_profile_name
  sg_compute_id        = module.security.sg_compute_id
  sg_k3s_internal_id   = module.security.sg_k3s_internal_id
}

module "load_balancer" {
  source            = "../../modules/load_balancer"
  environment       = var.environment
  vpc_id            = module.network.vpc_id
  sg_alb_id         = module.security.sg_alb_id
  public_subnet_ids = module.network.public_subnet_ids
  instance_ids      = module.compute.instance_ids
}
