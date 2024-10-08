module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"

  name                 = "compie-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b"]
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets       = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_dns_support = true
  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway = true
  

  tags     = merge(local.tags, { Name = "${local.tags.Environment}" })

  vpc_tags = {
    Name = "compie-vpc"
  }

  public_subnet_tags = {
    Name = "compie-public-subnet"
  }

  private_subnet_tags = {
    Name = "compie-private-subnet"
  }
}
