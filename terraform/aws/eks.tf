# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "18.29.0"

#   cluster_name    = var.eks_cluster_id
#   cluster_version = "1.23"

#   cluster_endpoint_private_access = true
#   cluster_endpoint_public_access  = true

#   vpc_id     = module.vpc.vpc_id
#   subnet_ids = module.vpc.private_subnets

#   enable_irsa = true

#   eks_managed_node_group_defaults = {
#     disk_size = 50
#   }

#   eks_managed_node_groups = {
#     general = {
#       desired_size = 1
#       min_size     = 1
#       max_size     = 10

#       labels = {
#         role = "general"
#       }

#       instance_types = ["t3.small"]
#       capacity_type  = "ON_DEMAND"
#     }

#     spot = {
#       desired_size = 1
#       min_size     = 1
#       max_size     = 10

#       labels = {
#         role = "spot"
#       }

#       taints = [{
#         key    = "market"
#         value  = "spot"
#         effect = "NO_SCHEDULE"
#       }]

#       instance_types = ["t3.micro"]
#       capacity_type  = "SPOT"
#     }
#   }
#   node_security_group_additional_rules = {
#     ingress_allow_access_from_control_plane = {
#       // https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/deploy/installation/#network-configuration
#       type                          = "ingress"
#       protocol                      = "tcp"
#       from_port                     = 9443
#       to_port                       = 9443
#       source_cluster_security_group = true
#       description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
#     }
#     egress_flux_source_controller = {
#       description      = "Allow egress traffic from cluster"
#       protocol         = "-1"
#       from_port        = 0
#       to_port          = 0
#       type             = "egress"
#       cidr_blocks      = ["0.0.0.0/0"]
#       ipv6_cidr_blocks = ["::/0"]
#     }
#     ingress_flux_source_controller = {
#       // https://github.com/fluxcd/flux2/discussions/2307
#       description      = "Node to node all ports/protocols"
#       protocol         = "-1"
#       from_port        = 0
#       to_port          = 0
#       type             = "ingress"
#       cidr_blocks      = ["0.0.0.0/0"]
#       ipv6_cidr_blocks = ["::/0"]
#     }
#   }
#   tags = {
#     Environment = "test"
#   }
# }

# # https://github.com/terraform-aws-modules/terraform-aws-eks/issues/2009
# data "aws_eks_cluster" "default" {
#   name = module.eks.cluster_id
# }

# data "aws_eks_cluster_auth" "default" {
#   name = module.eks.cluster_id
# }