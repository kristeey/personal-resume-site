locals {
  repo       = "kristeey/personal-resume-site" 
}

# Create Google Cloud Service Account to impersonate with federated access token
# https://github.com/terraform-google-modules/terraform-google-github-actions-runners/tree/master/modules/gh-oidc
resource "google_service_account" "gh_action_sa" {
  account_id   = "gh-action-to-gcr-sa"
  display_name = "Service Account that GH action impersonate to push images to GCR."
}

# This module handles the opinionated creation of infrastructure necessary to configure Workload Identity pools 
# and providers for authenticating to GCP using GitHub Actions OIDC tokens.
# This includes:
# - Creation of a Workload Identity pool
# - Configuring a Workload Identity provider
# - Granting external identities necessary IAM roles on Service Accounts

module "gh_oidc" {
  source      = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
  project_id  = var.project_id
  pool_id     = "gh-identity-pool"
  provider_id = "gh-identity-provider"
  sa_mapping = {
    "gh-action-service-account" = {
      sa_name   = "${google_service_account.gh_action_sa.id}"
      attribute = "attribute.repository/${local.repo}"
    }
  }
}