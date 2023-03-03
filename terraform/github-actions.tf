locals {
  repo = "kristeey/personal-resume-site" 
}

# Create Google Cloud Service Account to impersonate with federated access token
# https://github.com/terraform-google-modules/terraform-google-github-actions-runners/tree/master/modules/gh-oidc
resource "google_service_account" "gh_action_sa" {
  account_id   = "gh-action-to-gar-sa"
  display_name = "Service Account that GH action impersonate to push images to GAR."
}

resource "google_project_iam_member" "gh_action_gar_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.gh_action_sa.email}"
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

# Store SA name and provider name as github action secret

resource "github_actions_secret" "gh-action-sa-name" {
  repository       = var.repository_name
  secret_name      = "GCP_GH_SA_EMAIL"
  plaintext_value  = google_service_account.gh_action_sa.email
}

resource "github_actions_secret" "workload-identity-provider" {
  repository       = var.repository_name
  secret_name      = "GCP_GH_IDENTITY_PROVIDER"
  plaintext_value  = module.gh_oidc.provider_name
}