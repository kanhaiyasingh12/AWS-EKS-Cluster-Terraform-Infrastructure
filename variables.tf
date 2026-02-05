variable "region" {
  type = string
}

# VPC
variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

# EKS
variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

# Nodegroups (Multiple)
variable "node_groups" {
  type = map(object({
    instance_types = list(string)
    desired_size   = number
    min_size       = number
    max_size       = number
    disk_size      = optional(number, 30)
    capacity_type  = optional(string, "ON_DEMAND")
  }))
}

# Addons
variable "addons" {
  type = map(object({
    version = optional(string)
  }))
}

variable "tags" {
  type    = map(string)
  default = {}
}
