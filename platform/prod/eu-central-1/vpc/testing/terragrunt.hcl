# -----------------------------------------------------------------------------
# VPC for testing — Auto-generated
# Jira: INFRA-3003
# -----------------------------------------------------------------------------

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/Obulreddy58/keystone-modules-vpc.git//?ref=main"
}

inputs = {
  name     = "testing"
  vpc_cidr = "10.1.0.0/16"

  # 3 AZs
  availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]

  private_subnet_cidrs  = [cidrsubnet("10.1.0.0/16", 4, 0), cidrsubnet("10.1.0.0/16", 4, 1), cidrsubnet("10.1.0.0/16", 4, 2)]
  public_subnet_cidrs   = [cidrsubnet("10.1.0.0/16", 4, 3), cidrsubnet("10.1.0.0/16", 4, 4), cidrsubnet("10.1.0.0/16", 4, 5)]
  database_subnet_cidrs = [cidrsubnet("10.1.0.0/16", 4, 6), cidrsubnet("10.1.0.0/16", 4, 7), cidrsubnet("10.1.0.0/16", 4, 8)]

  enable_nat_gateway  = true
  single_nat_gateway  = false

  enable_flow_logs    = true
}
