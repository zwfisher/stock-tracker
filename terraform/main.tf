locals {
  env    = "prod"
  region = "nyc3"
}

provider "digitalocean" {
  token = var.do_token
}

provider "kubernetes" {
  host  = module.k8s.cluster_endpoint
  token = module.k8s.cluster_token
  cluster_ca_certificate = module.k8s.cluster_ca_certificate
}

provider "helm" {
  kubernetes = {
    host  = module.k8s.cluster_endpoint
    token = module.k8s.cluster_token
    cluster_ca_certificate = module.k8s.cluster_ca_certificate
  }
}

module "k8s" {
  source = "./modules/k8s"
  
  cluster_name     = "${local.env}-stock-tracker"
  region          = local.region
  cluster_version = "1.31.1-do.3"
  project         = "stock-tracker"
  node_pool_size  = "s-2vcpu-2gb"
}

module "k8s_bootstrap" {
  source = "./modules/k8s-bootstrap"
  
  project       = "stock-tracker"
  domain_name   = var.domain_name
  acme_email    = var.acme_email
  cluster_ready = module.k8s.cluster_id
  
  depends_on = [module.k8s]
}

resource "local_file" "kubeconfig" {
  content  = module.k8s.kubeconfig
  filename = "${path.root}/kubeconfig.yaml"
  
  file_permission = "0600"
}