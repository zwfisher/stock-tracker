# Traefik Ingress Controller
resource "helm_release" "traefik" {
  name       = "traefik"
  repository = "https://traefik.github.io/charts"
  chart      = "traefik"
  namespace  = "traefik-system"
  version    = var.traefik-version
  
  create_namespace = true
  
  values = [
    yamlencode({
      service = {
        type = "LoadBalancer"
        annotations = {
          "service.beta.kubernetes.io/do-loadbalancer-name" = "${var.project}-traefik-lb"
          "service.beta.kubernetes.io/do-loadbalancer-protocol" = "http"
          "service.beta.kubernetes.io/do-loadbalancer-healthcheck-path" = "/ping"
        }
      }
      
      ports = {
        web = {
          redirectTo = {
            port = "websecure"
            scheme = "https"
          }
        }
      }
      
      ingressRoute = {
        dashboard = {
          enabled = false
        }
      }
      
      pilot = {
        enabled = false
      }
    })
  ]
  
  depends_on = [var.cluster_ready]
}

# Cert-Manager
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  version    = "v1.15.3"
  
  create_namespace = true
  
  set {
    name  = "installCRDs"
    value = "true"
  }
  
  set {
    name  = "global.leaderElection.namespace"
    value = "cert-manager"
  }
  
  depends_on = [var.cluster_ready]
}

# Let's Encrypt ClusterIssuer
resource "kubernetes_manifest" "letsencrypt_issuer" {
  count = var.domain_name != null ? 1 : 0
  
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt-prod"
    }
    spec = {
      acme = {
        server = "https://acme-v02.api.letsencrypt.org/directory"
        email  = var.acme_email
        privateKeySecretRef = {
          name = "letsencrypt-prod"
        }
        solvers = [
          {
            http01 = {
              ingress = {
                class = "traefik"
              }
            }
          }
        ]
      }
    }
  }
  
  depends_on = [helm_release.cert_manager, helm_release.traefik]
}

# ArgoCD
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  version    = "7.4.3"
  
  create_namespace = true
  
  values = [
    yamlencode({
      server = {
        ingress = {
          enabled = var.domain_name != null
          ingressClassName = "traefik"
          hosts = var.domain_name != null ? ["argocd.${var.domain_name}"] : []
          tls = var.domain_name != null ? [
            {
              secretName = "argocd-server-tls"
              hosts      = ["argocd.${var.domain_name}"]
            }
          ] : []
          annotations = var.domain_name != null ? {
            "cert-manager.io/cluster-issuer" = "letsencrypt-prod"
            "traefik.ingress.kubernetes.io/router.tls" = "true"
          } : {}
        }
        
        config = {
          "application.instanceLabelKey" = "argocd.argoproj.io/instance"
          "server.rbac.log.enforce.enable" = "false"
          "exec.enabled" = "true"
          "admin.enabled" = "true"
          "timeout.hard.reconciliation" = "0s"
          "timeout.reconciliation" = "180s"
          "application.resourceTrackingMethod" = "annotation"
        }
        
        rbacConfig = {
          "policy.default" = "role:readonly"
          "policy.csv" = <<EOF
p, role:admin, applications, *, */*, allow
p, role:admin, certificates, *, *, allow
p, role:admin, clusters, *, *, allow
p, role:admin, repositories, *, *, allow
g, argocd-admins, role:admin
EOF
        }
      }
      
      applicationSet = {
        enabled = true
      }
      
      notifications = {
        enabled = false
      }
      
      dex = {
        enabled = false
      }
    })
  ]
  
  depends_on = [helm_release.traefik, helm_release.cert_manager]
}