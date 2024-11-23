module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.4.0"

 name = "my-eks"
 cidr = "10.0.0.0/16"

azs = ["us-west-1c","us-west-1b"]
private_subnets = ["10.0.0.0/19", "10.0.32.0/19"]
  public_subnets = ["10.0.64.0/19","10.0.96.0/19"]


  public_subnet_tags = {
    "kuberentes.io/role/elb"="1"

  }
  private_subnet_tags = {
    "kuberentes.io/role/internel-elb"="1"

  }
  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Env= "armond-dev"
  }

}
