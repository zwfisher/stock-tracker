resource "digitalocean_vpc" "main" {
  name     = "k8s-vpc"
  region   = var.region
  ip_range = "10.0.0.0/16"
}

resource "digitalocean_kubernetes_cluster" "main" {
  name          = var.cluster_name
  region        = var.region
  version       = var.cluster_version
  vpc_uuid      = digitalocean_vpc.main.id
  surge_upgrade = true

  tags = [var.project, "tf-managed"]

  maintenance_policy {
    start_time = "04:00"
    day        = "sunday"
  }

  node_pool {
    name       = var.node_pool_name
    size       = var.node_pool_size
    node_count = var.node_pool_count
    tags       = [var.project, "tf-managed"]

    auto_scale = true
    min_nodes  = 1
    max_nodes  = 3
  }
}
