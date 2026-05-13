module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "k8s-gitops-cluster"
  cluster_version = "1.30"

  # Allow the cluster to be accessed publicly so you can manage it from your laptop
  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Groups (The actual servers)
  eks_managed_node_groups = {
    nodes = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.medium"]
    }
  }

  # This allows your current AWS user to be an admin of the cluster
  enable_cluster_creator_admin_permissions = true
}