# DNS zone
resource "google_dns_managed_zone" "personal-resume" {
  name        = "sorensenstene"
  dns_name    = "sorensenstene.site."
  description = "Personal resume site DNS zone"
}

## GSA to be used with Workload Identity
# External DNS GSA

resource "google_service_account" "external-dns" {
  account_id = "external-dns-sa"
}

resource "google_project_iam_member" "dns-admin" {
  project = var.project_id
  role    = "roles/dns.admin"
  member  = "serviceAccount:${google_service_account.external-dns.email}"
}

resource "google_project_iam_member" "dns-wi-user" {
  project = var.project_id
  role    = "roles/iam.workloadIdentityUser"
  member  = "serviceAccount:${var.project_id}.svc.id.goog[external-dns/external-dns]"
}