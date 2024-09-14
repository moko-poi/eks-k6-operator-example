provider "aws" {
  default_tags {
    tags = {
      ManagedBy = "terraform"
    }
  }

  region              = local.region
  profile             = local.profile
  allowed_account_ids = [local.account_id]
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.61.0"
    }
  }
}
