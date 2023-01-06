module "external_dns_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.3.1"

  role_name                        = "external-dns"
  attach_external_dns_policy       = true
  external_dns_hosted_zone_arns   = [resource.aws_route53_zone.main.arn]

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:external-dns"]
    }
  }

}

// Install External DNS using Helm

resource "helm_release" "external_dns" {
  depends_on = [
    module.eks
  ]
  name = "external-dns"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  namespace  = "kube-system"
  version    = "6.12.2"

  set {
    name  = "provider"
    value = "aws"
  }

  set {
    name  = "domainFilters"
    value = "{${var.hosted_dns_zone_name}}"
  }

  set {
    name  = "sources"
    value = "{service,ingress}"
  }

  set {
    name  = "aws.zoneType"
    value = "public"
  }

  set {
    name  = "txtOwnerId"
    value = "external-dns"
  }

  set {
    // 'sync' used to make external dns clean up dns records if service/ingresses are deleted
    name  = "policy"
    value = "sync"
  }
  # If using IAM Roles for service account you need to create a service 
  # account that should be used to assume the AWS IAM role.
  set {
    name  = "serviceAccount.create"
    value = true
  }

  set {
    name  = "serviceAccount.name"
    value = "external-dns"
  }
  # Provide annotation to allow this service account to assume the AWS IAM role
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.external_dns_irsa_role.iam_role_arn
  }
}