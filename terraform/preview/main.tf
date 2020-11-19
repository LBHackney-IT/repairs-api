terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.16"
    }
  }
}

provider "aws" {
  profile = "repairs-api"
  region  = "eu-west-2"

  allowed_account_ids = ["561170585357"]
}

terraform {
  required_version = "~> 0.13.5"
}

locals {
  environment = "preview"
  aws_account = "561170585357"
  aws_region  = "eu-west-2"
}
