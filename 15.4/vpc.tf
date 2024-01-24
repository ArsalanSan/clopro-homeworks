module "vpc" {
  source   = "git::https://github.com/ArsalanSan/networks.git"
  vpc_name = var.env_network.vpc_name
  subnets  = local.subnets
}