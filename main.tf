module "vpc" {
  source = "./modules/vpc"

  vpc_name             = var.vpc_name
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  tags = var.tags
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  private_subnet_ids = module.vpc.private_subnet_ids

  tags = var.tags

  depends_on = [module.vpc]
}

module "nodegroup" {
  source = "./modules/nodegroup"

  cluster_name       = module.eks.cluster_name
  private_subnet_ids = module.vpc.private_subnet_ids

  node_groups = var.node_groups

  tags = var.tags

  depends_on = [module.eks]
}

resource "aws_eks_addon" "this" {
  for_each = var.addons

  cluster_name  = module.eks.cluster_name
  addon_name    = each.key
  addon_version = try(each.value.version, null)

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    module.nodegroup
  ]

  tags = var.tags
}
