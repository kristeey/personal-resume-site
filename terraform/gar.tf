resource "google_artifact_registry_repository" "personal-resume-repo" {
  location      = var.region
  repository_id = var.gar_repo_name
  description   = "Repo to store personal-resume webapp docker images."
  format        = "DOCKER"
}

resource "github_actions_secret" "gar-repo-name" {
  repository       = var.repository_name
  secret_name      = "GAR_REPO_NAME"
  plaintext_value  = google_artifact_registry_repository.personal-resume-repo.repository_id
}