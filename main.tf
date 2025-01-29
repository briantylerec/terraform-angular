module "network" {
  source = "./modules/network"
}

module "security_group" {
  source = "./modules/security-group"
  vpc_id = module.network.vpc_id
}

module "ec2_instance" {
  source              = "./modules/ec2-instance"
  aws_region          = var.aws_region
  ami_node            = var.ami_node
  ami_mongo           = var.ami_mongo
  vpc_id              = module.network.vpc_id
  public_subnet_ids    = module.network.subnet_ids
  node_security_group_id  = module.security_group.node_security_group_id
  mongo_security_group_id  = module.security_group.mongo_security_group_id
}

module "load_balancer" {
  source                = "./modules/load-balancer"
  availability_zones    = ["us-west-2a", "us-west-2b"]
  vpc_id                = module.network.vpc_id
  subnet_ids            = module.network.subnet_ids
  node_security_id      = module.security_group.node_security_group_id
  mongo_security_id     = module.security_group.mongo_security_group_id
  node_instance_id      = module.ec2_instance.node_instance_id
}

