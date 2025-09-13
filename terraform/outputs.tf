output "cluster_id" {
  description = "DOKS cluster ID"
  value       = module.k8s.cluster_id
}

output "cluster_endpoint" {
  description = "DOKS cluster API endpoint"
  value       = module.k8s.cluster_endpoint
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.k8s.vpc_id
}

output "kubeconfig_path" {
  description = "Path to kubeconfig file"
  value       = local_file.kubeconfig.filename
}

output "traefik_loadbalancer_ip" {
  description = "Traefik LoadBalancer external IP"
  value       = module.k8s_bootstrap.traefik_loadbalancer_ip
}

output "argocd_server_host" {
  description = "ArgoCD server hostname"
  value       = module.k8s_bootstrap.argocd_server_host
}