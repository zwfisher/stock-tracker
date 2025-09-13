variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
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