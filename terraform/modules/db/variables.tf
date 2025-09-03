variable "cluster_name" {
  description = "Name of the database cluster"
  type        = string
  default     = "db-cluster"
}

variable "engine" {
  description = "Database engine"
  type        = string
  default     = "pg"
}

variable "version" {
  description = "Database version"
  type        = string
  default     = "17"
}

variable "size" {
  description = "Size of the database cluster"
  type        = string
  default     = "db-s-1vcpu-1gb"
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "us-east-1"
}

variable "node_count" {
  description = "Number of nodes in the database cluster"
  type        = number
  default     = 1
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "stock-tracker"
}
