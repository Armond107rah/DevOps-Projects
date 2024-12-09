module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.29.0"

  cluster_name    = "armond-dev"
  cluster_version = "1.31"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  vpc_id                          = "vpc-0b2cac9a107ebf52c"
  subnet_ids = ["subnet-0f744185f621321fb", "subnet-01698c149369e360b"]
  enable_irsa                     = true

  eks_managed_node_group_defaults = {}
  eks_managed_node_groups = {
    master = {
      desired_size = 1
      min_size     = 0
      max_size     = 1
      lables = { role = "master" }

      instance_types = ["t2.medium"]
      cpacity_type = "ON_DEMAND"
      disk_size    = 40
    }


    worker = {
      desired_size = 0
      min_size     = 0
      max_size     = 3
      lables = { role = "worker" }
      lables = { "armonddev.io/role" : "worker" }

      instance_types = ["t2.medium"]
      cpacity_type = "ON_DEMAND"
      disk_size    = 40
      taints = [
        {
          key    = "worker"
          value  = "true"
          effect = "NO_SCHEDULE"
        }
      ]


    }
  }




  manage_aws_auth_configmap = true
  aws_auth_roles = [
    {
      rolearn  = module.eks_admins_iam_role.iam_role_arn
      username = module.eks_admins_iam_role.iam_role_name
      groups = ["system:masters"]
    },
  ]
}
# https://github.com/terraform-aws-modules/terraform-aws-eks/issues/2009
data "aws_eks_cluster" "default" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "default" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  # token                  = data.aws_eks_cluster_auth.default.token

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.default.id, "--profile" , "armond"]
    command     = "aws"
  }
}
