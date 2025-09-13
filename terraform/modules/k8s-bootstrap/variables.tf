variable "project" {
  description = "Project name for resource naming"
  type        = string
}

variable "traefik-version" {
  description = "Version of Traefik to install"
  type        = string
  default     = "28.3.0"
}

variable "domain_name" {
  description = "Domain name for ingress and certificates (optional)"
  type        = string
  default     = null
}

variable "acme_email" {
  description = "Email for Let's Encrypt certificates"
  type        = string
  default     = "admin@example.com"
}

variable "cluster_ready" {
  description = "Dependency to ensure cluster is ready"
  type        = any
  default     = null
}