# Local Values
locals {
  project    = "eks-k6-operator"
  region     = "ap-northeast-1"
  profile    = ""   # FIXME: Set your AWS profile
  account_id = ""   # FIXME: Set your AWS account ID
  cidrs      = [""] # FIXME: Set your CIDERS
}

# VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.project}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${local.region}a", "${local.region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
}

# EKS
module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name    = "${local.project}-eks"
  cluster_version = "1.30"

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.public_subnets

  cluster_endpoint_public_access           = true
  cluster_endpoint_public_access_cidrs     = local.cidrs
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    main = {
      desired_size   = 2
      instance_types = ["t3.medium"]
    }
  }
}
