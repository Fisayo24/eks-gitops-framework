# ==============================================================================
# 1. KMS KEY FOR EKS SECRETS ENVELOPE ENCRYPTION
# ==============================================================================
resource "aws_kms_key" "this" {
  description             = "KMS Key for EKS Cluster Secrets Encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Environment = "dev"
  }
}

resource "aws_kms_alias" "this" {
  name          = "alias/eks-cluster-key"
  target_key_id = aws_kms_key.this.key_id
}

# ==============================================================================
# 2. IAM ROLE FOR THE EKS CONTROL PLANE
# ==============================================================================
resource "aws_iam_role" "this" {
  name = "eks-cluster-control-plane-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.this.name
}

# ==============================================================================
# 3. EKS CONTROL PLANE DEFINITION
# ==============================================================================
resource "aws_eks_cluster" "this" {
  name     = "eks-gitops-framework-cluster"
  role_arn = aws_iam_role.this.arn
  version  = "1.31" # Up-to-date stable version

  vpc_config {
    # Tightly binds control plane to the private subnets from your VPC module
    subnet_ids              = module.vpc.private_subnets
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  encryption_config {
    provider {
      key_arn = aws_kms_key.this.arn
    }
    resources = ["secrets"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy
  ]
}

# ==============================================================================
# 4. STRATEGIC COOLDOWN TO PREVENT RACE CONDITIONS
# ==============================================================================
resource "time_sleep" "this" {
  depends_on = [aws_eks_cluster.this]

  create_duration = "30s"
}

# ==============================================================================
# 5. IAM ROLE FOR WORKER NODES
# ==============================================================================
resource "aws_iam_role" "nodes" {
  name = "eks-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "worker_node" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "registry" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}

# ==============================================================================
# 6. EKS MANAGED NODE GROUP DEFINITION
# ==============================================================================
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "managed-worker-nodes"
  node_role_arn   = aws_iam_role.nodes.arn
  subnet_ids      = module.vpc.private_subnets

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  ami_type       = "AL2023_x86_64_STANDARD" # AWS Linux 2023 optimized for EKS
  instance_types = ["t3.medium"]

  depends_on = [
    time_sleep.this, # Guarantees control plane API is stable before nodes join
    aws_iam_role_policy_attachment.worker_node,
    aws_iam_role_policy_attachment.cni,
    aws_iam_role_policy_attachment.registry
  ]
}
