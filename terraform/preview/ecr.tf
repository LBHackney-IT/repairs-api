module "ecr" {
  source      = "../modules/ecr"
  environment = local.environment
}
