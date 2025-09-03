locals {
  env    = "prod"
  region = "us-east-1"
}

provider "digitalocean" {
  token = var.do_token
}

provider "kubernetes" {
  config_path = local_file.kubernetes.filename
}

provider "helm" {
  kubernetes = {
    config_path = local_file.kubernetes.filename
  }
}

module "k8s" {

}

resource "local_file" "kubernetes" {
  content  = module.kubernetes_cluster.kube_config
  filename = "${path.root}/kubeconfig.yaml"
}