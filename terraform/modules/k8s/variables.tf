variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
  default     = "k8s"
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "nyc3"
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "k8s-vpc"
}

variable "node_pool_name" {
  description = "Name of the node pool"
  type        = string
  default     = "k8s-node-pool"
}

variable "node_pool_size" {
  description = "Size of nodes in the pool"
  type        = string
  default     = "s-2vcpu-4gb"
}

variable "node_pool_count" {
  description = "Number of nodes in the pool"
  type        = number
  default     = 1
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "domain_name" {
  description = "Domain name for ingress (optional)"
  type        = string
  default     = null
}