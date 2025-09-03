output "cluster_id" {
  description = "ID of the Kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.main.id
}

output "cluster_endpoint" {
  description = "Endpoint of the Kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.main.endpoint
}

output "kubeconfig" {
  description = "Kubernetes config"
  value       = digitalocean_kubernetes_cluster.main.kube_config[0].raw_config
  sensitive   = true
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = digitalocean_vpc.main.id
}