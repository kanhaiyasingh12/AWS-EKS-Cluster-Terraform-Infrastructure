region = "ap-south-1"

# VPC
vpc_name = "eks-vpc"
vpc_cidr = "10.0.0.0/16"

azs = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24",
  "10.0.3.0/24"
]

private_subnet_cidrs = [
  "10.0.101.0/24",
  "10.0.102.0/24",
  "10.0.103.0/24"
]

# EKS
cluster_name    = "eks"
cluster_version = "1.29"

# NodeGroups
node_groups = {
  on_demand = {
    instance_types = ["t3.medium"]
    desired_size   = 2
    min_size       = 1
    max_size       = 4
    disk_size      = 30
    capacity_type  = "ON_DEMAND"
  }

  spot = {
    instance_types = ["t3.large"]
    desired_size   = 1
    min_size       = 1
    max_size       = 3
    disk_size      = 50
    capacity_type  = "SPOT"
  }
}

# Addons
addons = {
  vpc-cni = {
    version = "v1.18.1-eksbuild.1"
  }

  coredns = {
    version = "v1.11.1-eksbuild.4"
  }

  kube-proxy = {
    version = "v1.29.0-eksbuild.1"
  }

  aws-ebs-csi-driver = {
    version = "v1.30.0-eksbuild.1"
  }
}

tags = {
  Environment = "prod"
  Owner       = "infra-team"
}
