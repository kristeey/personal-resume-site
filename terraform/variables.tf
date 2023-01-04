
variable "region" {
    type        = string
    description = "The AWS region to provision resources in"
    default      = "eu-north-1"
}

variable "eks_cluster_id" {
    type        = string
    description = "The id/name of the EKS cluster."
    default     = "resume-cluster"
}

variable "hosted_dns_zone_name" {
    type        = string
    description = "The name of the Route53 hosted zone"
    default     = "sorensenstene.site"
}

// Flux CD 

variable "github_owner" {
  type        = string
  description = "github owner"
}

variable "github_token" {
  type        = string
  description = "github token"
}

variable "repository_name" {
  type        = string
  description = "github repository name"
  default     = "personal-resume-site"
}

# variable "repository_visibility" {
#   type        = string
#   description = "How visible is the github repo"
#   default     = "public"
# }

# variable "branch" {
#   type        = string
#   description = "Branch name"
#   default     = "main"
# }

variable "flux_sync_target_path" {
  type        = string
  description = "flux sync target path"
  default     = "gitops/cluster"
}

// ECR
variable "ecr_repo_name" {
  type        = string
  description = "ECR repository name for storing app Docker images"
  default     = "personal-resume-webapp"
}