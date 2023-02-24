
# // Create role to let the LB Controller have permissions to create and
# // manage AWS load balancers.
# module "aws_load_balancer_controller_irsa_role" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
#   version = "5.3.1"

#   role_name = "aws-load-balancer-controller"

#   attach_load_balancer_controller_policy = true

#   oidc_providers = {
#     ex = {
#       provider_arn               = module.eks.oidc_provider_arn
#       namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
#     }
#   }
# }

# // Install AWS LB controller using Helm

# resource "helm_release" "aws_load_balancer_controller" {
#   name = "aws-load-balancer-controller"

#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller"
#   namespace  = "kube-system"
#   version    = "1.4.4"

#   set {
#     name  = "replicaCount"
#     value = 1
#   }

#   set {
#     name  = "clusterName"
#     value = module.eks.cluster_id
#   }

#   # If using IAM Roles for service account you need to create a service 
#   # account that should be used to assume the AWS IAM role.
#   set {
#     name  = "serviceAccount.create"
#     value = true
#   }

#   set {
#     name  = "serviceAccount.name"
#     value = "aws-load-balancer-controller"
#   }
#   # Provide annotation to allow this service account to assume the AWS IAM role
#   set {
#     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = module.aws_load_balancer_controller_irsa_role.iam_role_arn
#   }
# }

# // The load balancer controller uses tags to discover subnets in which it 
# // can create load balancers. We also need to update terraform vpc module to include them. 
# // It uses an elb tag to deploy public load balancers to expose services to the internet 
# // and internal-elb for the private load balancers to expose services only within your VPC