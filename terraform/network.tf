
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_service
resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
}

resource "google_project_service" "container" {
  service = "container.googleapis.com"
}

## VPC
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "main" {
  name                            = "personal-resume-main"
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = false # we will create our own subnets
  mtu                             = 1460  # minimum value form maximum transmission unit in byte
  delete_default_routes_on_create = false # delete default route to internett

  depends_on = [
    google_project_service.compute,
    google_project_service.container
  ]
}

## SUBNET
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
resource "google_compute_subnetwork" "private" {
  name                     = "private"
  ip_cidr_range            = "10.0.0.0/18" # 16 000 ip adresses
  region                   = var.region
  network                  = google_compute_network.main.id
  private_ip_google_access = true # VMs in subnet without external IPs can still reach google API and services

  # Kubernetes nodes will use IPs from main CIDR range
  # Kubernetes pods will use IPs from secondary IP range
  secondary_ip_range {
    range_name    = "k8s-pod-range"
    ip_cidr_range = "10.48.0.0/14"
  }
  secondary_ip_range {
    range_name    = "k8s-service-range"
    ip_cidr_range = "10.52.0.0/20"
  }
}

# FIREWALL RULES
## Create a firewall rule that allows calling valitaingwebhook API on master node in GKE
## which is redirected to 8443 not 443 (as in regular kubernetes setup).

data "google_compute_instance_group" "resume-cluster-node-grp" {
    depends_on = [google_container_node_pool.general]
    self_link = "${replace(google_container_node_pool.general.instance_group_urls[0], "instanceGroupManagers", "instanceGroups")}"
}

data "google_compute_instance" "resume-cluster-node-inst" {
    depends_on = [data.google_compute_instance_group.resume-cluster-node-grp]
    self_link = sort(data.google_compute_instance_group.resume-cluster-node-grp.instances)[0]    
}

resource "google_compute_firewall" "validating-webhook" {
  name    = "allow-validating-webhook"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports = ["8443","9443"]
  }
  direction = "INGRESS"

  source_ranges = [google_container_cluster.resume_cluster.private_cluster_config[0].master_ipv4_cidr_block]
  target_tags = [sort(data.google_compute_instance.resume-cluster-node-inst.tags)[0]]
}

resource "google_compute_firewall" "health-check" {
  name    = "allow-health-check"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports = ["9440"]
  }
  direction = "INGRESS"

  source_ranges = [google_container_cluster.resume_cluster.private_cluster_config[0].master_ipv4_cidr_block]
  target_tags = [sort(data.google_compute_instance.resume-cluster-node-inst.tags)[0]]
}

## ROUTER
# create Cloud Router to advertise routes, and use it with NAT Gateway to allow
# VMs without public IP adresses to access internet

# # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router
resource "google_compute_router" "router" {
  name    = "router"
  region  = var.region
  network = google_compute_network.main.id
}

# # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat
# # Only advertise Cloud NAT to private subnet
resource "google_compute_router_nat" "nat" {
  name   = "nat"
  router = google_compute_router.router.name
  region = var.region

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ip_allocate_option             = "MANUAL_ONLY"

  subnetwork {
    name                    = google_compute_subnetwork.private.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  nat_ips = [google_compute_address.nat.self_link]
}

# # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address
resource "google_compute_address" "nat" {
  name         = "nat"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"

  depends_on = [google_project_service.compute]
}