locals {
  known_hosts = "github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg="

  // The following patches are saved as files in github and patched into the flux manifests
  // using patchesStrategicMerge in the kustomization.yaml in the flux-system folder in github.
  patches = {
    aws-ecr-autologin-arg = <<EOT
apiVersion: apps/v1
kind: Deployment
metadata:
  name: image-reflector-controller
  namespace: flux-system
spec:
  template:
    spec:
      containers:
      - args:
        - --aws-autologin-for-ecr
EOT
  }
}

resource "tls_private_key" "main" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

# Flux
data "flux_install" "main" {
  version = "v0.38.2"
  target_path = var.flux_sync_target_path
  components = [
    "source-controller",
    "kustomize-controller",
    "helm-controller",
    //notification-controller
  ]
  components_extra = [
    "image-reflector-controller",
    "image-automation-controller"
  ]
  watch_all_namespaces = true
}

data "flux_sync" "main" {
  target_path = var.flux_sync_target_path
  url         = "ssh://git@github.com/${var.github_owner}/${var.repository_name}"
  branch      = var.github_branch
  patch_names = keys(local.patches)
}

# Kubernetes
resource "kubernetes_namespace" "flux_system" {
  depends_on = [
    module.eks
  ]
  metadata {
    name = "flux-system"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}

data "kubectl_file_documents" "install" {
  content = data.flux_install.main.content
}

data "kubectl_file_documents" "sync" {
  content = data.flux_sync.main.content
}

locals {
  install = [for v in data.kubectl_file_documents.install.documents : {
    data : yamldecode(v)
    content : v
    }
  ]
  sync = [for v in data.kubectl_file_documents.sync.documents : {
    data : yamldecode(v)
    content : v
    }
  ]
}

resource "kubectl_manifest" "install" {
  for_each   = { for v in local.install : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body  = each.value
}

resource "kubectl_manifest" "sync" {
  for_each   = { for v in local.sync : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body  = each.value
}

resource "kubernetes_secret" "main" {
  depends_on = [kubectl_manifest.install]

  metadata {
    name      = data.flux_sync.main.secret
    namespace = data.flux_sync.main.namespace
  }

  data = {
    identity       = tls_private_key.main.private_key_pem
    "identity.pub" = tls_private_key.main.public_key_pem
    known_hosts    = local.known_hosts
  }
}


# # GitHub - Used first time only, then removed from state

# resource "github_repository" "resume_repo" {
#   name       = var.repository_name
#   visibility = var.repository_visibility
#   auto_init  = false
#   description = "My personal website containing resume"
# }

# resource "github_branch_default" "main" {
#   repository = github_repository.resume_repo.name
#   branch     = var.github_branch
# }

# resource "github_repository_deploy_key" "main" {
#   title      = "resume-cluster"
#   repository = github_repository.resume_repo.name
#   key        = tls_private_key.main.public_key_openssh
#   read_only  = true
# }

resource "github_repository_file" "install" {
  repository = var.repository_name
  file       = data.flux_install.main.path
  content    = data.flux_install.main.content
  branch     = var.github_branch
  overwrite_on_create = true
}

resource "github_repository_file" "sync" {
  repository = var.repository_name
  file       = data.flux_sync.main.path
  content    = data.flux_sync.main.content
  branch     = var.github_branch
  overwrite_on_create = true
}

resource "github_repository_file" "kustomize" {
  repository = var.repository_name
  file       = data.flux_sync.main.kustomize_path
  content    = data.flux_sync.main.kustomize_content
  branch     = var.github_branch
  overwrite_on_create = true
}

resource "github_repository_file" "patches" {
  #  `patch_file_paths` is a map keyed by the keys of `flux_sync.main`
  #  whose values are the paths where the patch files should be installed.
  for_each   = data.flux_sync.main.patch_file_paths
  repository = var.repository_name
  file       = each.value
  content    = local.patches[each.key] # Get content of our patch files
  branch     = var.github_branch
}