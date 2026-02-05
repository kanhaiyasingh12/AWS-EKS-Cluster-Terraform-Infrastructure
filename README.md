# AWS EKS Cluster Terraform Infrastructure

A production-ready, modular Terraform configuration for deploying Amazon Elastic Kubernetes Service (EKS) clusters with custom VPC networking, managed node groups, and essential EKS add-ons.

## 🏗️ Architecture Overview

This infrastructure deploys a complete EKS environment consisting of:

- **Custom VPC** with public and private subnets across multiple availability zones
- **EKS Cluster** with configurable Kubernetes version
- **Managed Node Groups** supporting both ON_DEMAND and SPOT instances
- **EKS Add-ons** including VPC CNI, CoreDNS, kube-proxy, and EBS CSI driver
- **High Availability** with multi-AZ deployment
- **Cost Optimization** through single NAT Gateway architecture

## 📋 Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.5.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- AWS account with permissions to create EKS, VPC, IAM, and EC2 resources
- [kubectl](https://kubernetes.io/docs/tasks/tools/) for cluster interaction (optional)

## 🚀 Quick Start

### 1. Clone and Navigate

```bash
cd Eks_Cluster
```

### 2. Configure Variables

Review and modify `terraform.tfvars` to match your requirements:

```hcl
region = "ap-south-1"
cluster_name = "eks"
cluster_version = "1.29"
vpc_cidr = "10.0.0.0/16"
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Review the Plan

```bash
terraform plan
```

### 5. Deploy Infrastructure

```bash
terraform apply
```

### 6. Configure kubectl

```bash
aws eks update-kubeconfig --region ap-south-1 --name eks
```

## 📁 Project Structure

```
Eks_Cluster/
├── main.tf                      # Root module orchestration
├── variables.tf                 # Root module input variables
├── outputs.tf                   # Root module outputs
├── providers.tf                 # AWS provider configuration
├── version.tf                   # Terraform and provider version constraints
├── terraform.tfvars             # Variable values (customize this)
│
└── modules/
    ├── vpc/                     # VPC module
    │   ├── main.tf             # VPC, subnets, NAT, IGW resources
    │   ├── variables.tf        # VPC module variables
    │   └── outputs.tf          # VPC ID and subnet outputs
    │
    ├── eks/                     # EKS cluster module
    │   ├── main.tf             # EKS cluster and IAM resources
    │   ├── variables.tf        # EKS module variables
    │   └── outputs.tf          # Cluster endpoint and details
    │
    └── nodegroup/               # EKS node group module
        ├── main.tf             # Node groups and IAM resources
        ├── variables.tf        # Node group variables
        └── outputs.tf          # Node group names
```

## 🔧 Configuration Details

### VPC Module

Creates a complete networking stack:

- **VPC**: Custom CIDR with DNS support enabled
- **Public Subnets**: 3 subnets across different AZs with auto-assign public IP
- **Private Subnets**: 3 subnets for EKS nodes and workloads
- **Internet Gateway**: For public subnet internet access
- **NAT Gateway**: Single NAT in first public subnet (cost-optimized)
- **Route Tables**: Separate routing for public and private subnets
- **Kubernetes Tags**: Automatic tagging for AWS Load Balancer Controller

### EKS Module

Deploys a managed Kubernetes cluster:

- **IAM Roles**: Cluster service role with required policies
- **Cluster Configuration**: 
  - Configurable Kubernetes version
  - Public and private endpoint access enabled
  - Deployed in private subnets for security
- **Policies Attached**:
  - AmazonEKSClusterPolicy
  - AmazonEKSVPCResourceController

### Node Group Module

Manages worker nodes with flexibility:

- **IAM Roles**: Node instance role with required policies
- **Multiple Node Groups**: Support for different instance configurations
- **Capacity Types**: ON_DEMAND and SPOT instances
- **Auto Scaling**: Configurable min/max/desired sizes
- **Storage**: Customizable EBS volume size per node group
- **Policies Attached**:
  - AmazonEKSWorkerNodePolicy
  - AmazonEKS_CNI_Policy
  - AmazonEC2ContainerRegistryReadOnly

### EKS Add-ons

Essential cluster functionality:

- **vpc-cni**: AWS VPC CNI plugin for pod networking
- **coredns**: Cluster DNS service
- **kube-proxy**: Network proxy on each node
- **aws-ebs-csi-driver**: Persistent volume support using EBS

## 📊 Input Variables

### Core Variables

| Variable | Type | Description | Required |
|----------|------|-------------|----------|
| `region` | string | AWS region for deployment | Yes |
| `cluster_name` | string | Name of the EKS cluster | Yes |
| `cluster_version` | string | Kubernetes version (e.g., "1.29") | Yes |

### VPC Variables

| Variable | Type | Description | Default |
|----------|------|-------------|---------|
| `vpc_name` | string | Name tag for VPC | - |
| `vpc_cidr` | string | CIDR block for VPC | - |
| `azs` | list(string) | Availability zones | - |
| `public_subnet_cidrs` | list(string) | CIDR blocks for public subnets | - |
| `private_subnet_cidrs` | list(string) | CIDR blocks for private subnets | - |

### Node Group Variables

| Variable | Type | Description | Default |
|----------|------|-------------|---------|
| `node_groups` | map(object) | Map of node group configurations | - |
| `instance_types` | list(string) | EC2 instance types | - |
| `desired_size` | number | Desired number of nodes | - |
| `min_size` | number | Minimum number of nodes | - |
| `max_size` | number | Maximum number of nodes | - |
| `disk_size` | number | EBS volume size in GB | 30 |
| `capacity_type` | string | ON_DEMAND or SPOT | ON_DEMAND |

### Add-on Variables

| Variable | Type | Description |
|----------|------|-------------|
| `addons` | map(object) | EKS add-ons with optional versions |

### Common Variables

| Variable | Type | Description | Default |
|----------|------|-------------|---------|
| `tags` | map(string) | Tags to apply to all resources | {} |

## 📤 Outputs

| Output | Description |
|--------|-------------|
| `vpc_id` | ID of the created VPC |
| `private_subnet_ids` | List of private subnet IDs |
| `cluster_name` | Name of the EKS cluster |
| `cluster_endpoint` | Endpoint URL for the EKS cluster |

## 🎯 Example Configuration

The included `terraform.tfvars` provides a complete example:

```hcl
# Production-grade EKS cluster in Mumbai region
region = "ap-south-1"

# VPC Configuration
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

# EKS Cluster
cluster_name = "eks"
cluster_version = "1.29"

# Node Groups: Mix of on-demand and spot instances
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

# Essential EKS Add-ons
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
```

## 🔐 Security Considerations

- **Private Node Placement**: Worker nodes are deployed in private subnets
- **Endpoint Access**: Both public and private endpoints enabled (customize as needed)
- **IAM Roles**: Least-privilege IAM roles following AWS best practices
- **Network Isolation**: Separate public/private subnet tiers
- **Add-on Updates**: Automatic conflict resolution for add-on updates

## 💰 Cost Optimization

- **Single NAT Gateway**: Shared across all AZs to reduce costs
- **Spot Instances**: Support for SPOT capacity type in node groups
- **Right-sizing**: Configurable instance types and node counts
- **Auto-scaling**: Min/max/desired sizing for dynamic scaling

## 🔄 Customization

### Add More Node Groups

```hcl
node_groups = {
  # Existing groups...
  
  gpu_nodes = {
    instance_types = ["g4dn.xlarge"]
    desired_size   = 1
    min_size       = 0
    max_size       = 2
    disk_size      = 100
    capacity_type  = "ON_DEMAND"
  }
}
```

### Change Kubernetes Version

```hcl
cluster_version = "1.30"  # Update to desired version
```

### Modify VPC CIDR

```hcl
vpc_cidr = "172.16.0.0/16"
private_subnet_cidrs = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
public_subnet_cidrs = ["172.16.101.0/24", "172.16.102.0/24", "172.16.103.0/24"]
```

## 🧹 Cleanup

To destroy all resources:

```bash
terraform destroy
```

**Warning**: This will permanently delete your EKS cluster, node groups, VPC, and all associated resources.

## 📚 Additional Resources

- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [EKS Best Practices Guide](https://aws.github.io/aws-eks-best-practices/)
- [kubectl Documentation](https://kubernetes.io/docs/reference/kubectl/)

## 🐛 Troubleshooting

### Issue: Node group creation fails

**Solution**: Ensure you have sufficient EC2 capacity limits in your AWS account for the chosen instance types.

### Issue: Cannot connect to cluster

**Solution**: Update your kubeconfig:
```bash
aws eks update-kubeconfig --region <your-region> --name <cluster-name>
```

### Issue: Add-on installation fails

**Solution**: The configuration uses `OVERWRITE` resolution strategy. Check add-on version compatibility with your Kubernetes version.

### Issue: VPC quota exceeded

**Solution**: Check VPC limits in your AWS account or request a limit increase through AWS Support.

## 📝 Version Requirements

- **Terraform**: >= 1.5.0
- **AWS Provider**: >= 5.0
- **Kubernetes**: 1.29 (configurable)

## 🤝 Contributing

This is a template infrastructure configuration. Customize it according to your organization's requirements:

1. Review security group configurations
2. Adjust IAM policies based on your security requirements
3. Implement additional monitoring and logging solutions
4. Add backup and disaster recovery procedures
5. Configure RBAC and pod security policies

## 📄 License

This infrastructure code is provided as-is for educational and production use. Ensure you review and understand all resource costs and security implications before deployment.

## ⚠️ Important Notes

1. **NAT Gateway Costs**: Single NAT Gateway is used for cost optimization. For production HA, consider NAT Gateways per AZ.
2. **Add-on Versions**: Update add-on versions according to your Kubernetes version compatibility.
3. **Instance Limits**: Ensure your AWS account has sufficient EC2 instance limits for chosen types.
4. **State Management**: For production, use remote state backend (S3 + DynamoDB) instead of local state.
5. **Spot Instances**: Spot instances can be interrupted. Use for fault-tolerant workloads only.

## 🎓 Learning Resources

For those new to EKS and Terraform:

- [HashiCorp Learn - EKS](https://learn.hashicorp.com/collections/terraform/kubernetes)
- [AWS EKS Workshop](https://www.eksworkshop.com/)
- [Terraform AWS Examples](https://github.com/hashicorp/terraform-provider-aws/tree/main/examples)

---

**Built with ❤️ for scalable Kubernetes infrastructure on AWS**
