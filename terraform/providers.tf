terraform {
  backend "gcs" {
    bucket = "tf-state-personal-resume"
    prefix = "terraform/state"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6.0"
    }
    github = {
      source  = "integrations/github"
      version = ">= 4.5.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.2"
    }
    flux = {
      source  = "fluxcd/flux"
      version = ">= 0.22.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.1.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# provider "aws" {
#   region = "eu-north-1"
# }

provider "kubectl" {
  host                   = google_container_cluster.resume_cluster.endpoint
  cluster_ca_certificate = base64decode(google_container_cluster.resume_cluster.master_auth.0.cluster_ca_certificate)
  load_config_file       = false

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", google_container_cluster.resume_cluster.id]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = google_container_cluster.resume_cluster.endpoint
    cluster_ca_certificate = base64decode(google_container_cluster.resume_cluster.master_auth.0.cluster_ca_certificate)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", google_container_cluster.resume_cluster.id]
      command     = "aws"
    }
  }
}

provider "flux" {}

provider "kubernetes" {
  host                   = google_container_cluster.resume_cluster.endpoint
  cluster_ca_certificate = base64decode(google_container_cluster.resume_cluster.master_auth.0.cluster_ca_certificate)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", google_container_cluster.resume_cluster.id]
    command     = "aws"
  }
}

provider "github" {
  owner = var.github_owner
  token = var.github_token
}