
# # resource "github_repository" "resume_repo" {
# #   name       = var.repository_name
# #   visibility = var.repository_visibility
# #   auto_init  = false
# #   description = "My personal website containing resume"
# # }

# # resource "github_branch_default" "main" {
# #   repository = github_repository.resume_repo.name
# #   branch     = var.github_branch
# # }

locals {
  kustomization-override = <<EOT
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- gotk-sync.yaml
- gotk-components.yaml
- helmrepository.yaml
- image-update-automation.yaml
- sync.yaml
patches:
  - patch: |
      apiVersion: v1
      kind: ServiceAccount
      metadata:
        name: image-reflector-controller
        annotations:
          iam.gke.io/gcp-service-account: ${google_service_account.kubernetes.email}
    target:
      kind: ServiceAccount
      name: image-reflector-controller
EOT
}

resource "tls_private_key" "main" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "github_repository_deploy_key" "main" {
  title      = "flux-deploy-key"
  repository = var.repository_name
  key        = tls_private_key.main.public_key_openssh
  read_only  = false
}

resource "flux_bootstrap_git" "main" {
  depends_on = [github_repository_deploy_key.main]

  version = "v0.41.0"
  path = var.flux_sync_target_path
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
  kustomization_override = local.kustomization-override
}

# resource "github_repository_file" "patches" {
#   #  `patch_file_paths` is a map keyed by the keys of `flux_sync.main`
#   #  whose values are the paths where the patch files should be installed.
#   for_each   = data.flux_sync.main.patch_file_paths
#   repository = var.repository_name
#   file       = each.value
#   content    = local.patches[each.key] # Get content of our patch files
#   branch     = var.github_branch
# }