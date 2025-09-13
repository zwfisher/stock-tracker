output "traefik_loadbalancer_ip" {
  description = "Traefik LoadBalancer external IP"
  value       = helm_release.traefik.status[0].load_balancer[0].ingress[0].ip
}

output "argocd_server_host" {
  description = "ArgoCD server hostname"
  value       = var.domain_name != null ? "argocd.${var.domain_name}" : "localhost"
}

output "argocd_admin_password_secret" {
  description = "Secret name containing ArgoCD admin password"
  value       = "argocd-initial-admin-secret"
}