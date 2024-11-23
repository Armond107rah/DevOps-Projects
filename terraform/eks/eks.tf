module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.29.0"

  cluster_name = "armond-dev"
  cluster_version = "1.31"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true
  vpc_id = "vpc-0b2cac9a107ebf52c"
  subnet_ids = ["subnet-0f744185f621321fb","subnet-01698c149369e360b"]
  enable_irsa = true

  eks_managed_node_group_defaults = {}
  eks_managed_node_groups = {
    master = {
      desired_size = 1
      min_size     = 1
      max_size     = 1
      lables = { role = "master" }

      instance_types = ["t2.micro"]
      cpacity_type = "ON_DEMAND"
      disk_size    = 40
    }


    worker = {
      desired_size = 0
      min_size     = 0
      max_size     = 3
      lables = { role = "worker" }
      lables = { "armonddev.io/role": "worker" }

      instance_types = ["t2.medium"]
      cpacity_type = "ON_DEMAND"
      disk_size    = 40
      taints = [{
        key    = "worker"
        value  = "true"
        effect = "NO_SCHEDULE"
      }]


    }
  }

}