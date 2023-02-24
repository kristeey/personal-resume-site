# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster
resource "google_container_cluster" "resume_cluster" {
  name                     = var.gke_cluster_id
  location                 = var.zone
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.main.self_link
  subnetwork               = google_compute_subnetwork.private.self_link
  logging_service          = "none" # No external logging service needed 
  monitoring_service       = "none" # Installing prometheus for montioring later
  networking_mode          = "VPC_NATIVE"

  # Optional, if you want multi-zonal cluster
  # node_locations = [
  #   "us-central1-b"
  # ]

  addons_config {
    http_load_balancing {
      disabled = true # Disable since we are using Nginx-loadbalancer
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "personal-resume-376620.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pod-range"
    services_secondary_range_name = "k8s-service-range"
  }

  private_cluster_config {
    enable_private_nodes    = true  # Nodes will only use private IPs from private subnet
    enable_private_endpoint = false # Keep false to be able to access kubernetes API from computer
    master_ipv4_cidr_block  = "172.16.0.0/28" # Controll plane CIDR range
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "kubernetes" {
  account_id = "kubernetes"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool
resource "google_container_node_pool" "general" {
  name       = "general"
  cluster    = google_container_cluster.resume_cluster.id
  node_count = 1

  management {
    auto_repair  = true
    auto_upgrade = true
  }
  autoscaling {
    min_node_count = 1
    max_node_count = 4
  }

  node_config {
    preemptible  = true
    machine_type = "e2-small"

    labels = {
      role = "general"
    }

    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

