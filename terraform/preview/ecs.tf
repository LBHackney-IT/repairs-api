module "ecs" {
  source      = "../modules/ecs"
  environment = local.environment
  aws_account = local.aws_account
  aws_region  = local.aws_region

  vpc_id   = module.network.vpc_id
  subnet_a = module.network.subnet_a
  subnet_b = module.network.subnet_b
  subnet_c = module.network.subnet_c

  target_group_arn = module.load_balancer.target_group_arn
}
