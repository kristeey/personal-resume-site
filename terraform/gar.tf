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

## Give cluster default SA read permission on GAR
# to let workloads in the cluster pull images from here.
resource "google_project_iam_member" "gar-reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_container_cluster.resume_cluster.node_pool[0].node_config[0].service_account}"
}