
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
