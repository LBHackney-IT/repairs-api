module "network" {
  source      = "../modules/network"
  environment = local.environment
  aws_account = local.aws_account
  aws_region  = local.aws_region
}
