variable "cluster_name" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

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

variable "tags" {
  type    = map(string)
  default = {}
}
