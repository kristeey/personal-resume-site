
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

## ROUTER
# create Cloud Router to advertise routes, and use it with NAT Gateway to allow
# VMs without public IP adresses to access internet


# # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router
# resource "google_compute_router" "router" {
#   name    = "router"
#   region  = var.region
#   network = google_compute_network.main.id
# }

# # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat
# # Only advertise Cloud NAT to private subnet
# resource "google_compute_router_nat" "nat" {
#   name   = "nat"
#   router = google_compute_router.router.name
#   region = var.region

#   source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
#   nat_ip_allocate_option             = "MANUAL_ONLY"

#   subnetwork {
#     name                    = google_compute_subnetwork.private.id
#     source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
#   }

#   nat_ips = [google_compute_address.nat.self_link]
# }

# # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address
# resource "google_compute_address" "nat" {
#   name         = "nat"
#   address_type = "EXTERNAL"
#   network_tier = "PREMIUM"

#   depends_on = [google_project_service.compute]
# }