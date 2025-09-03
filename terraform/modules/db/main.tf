resource "digitalocean_database_cluster" "main" {
  name       = var.cluster_name
  engine     = var.engine
  version    = var.version
  size       = var.size
  region     = var.region
  node_count = var.node_count

  tags = [var.project, "tf-managed"]
}
