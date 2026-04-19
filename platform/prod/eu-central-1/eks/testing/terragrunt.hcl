# -----------------------------------------------------------------------------
# EKS Cluster: testing — Auto-generated
# Jira: INFRA-3003
# -----------------------------------------------------------------------------

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/Obulreddy58/keystone-modules.git//eks?ref=main"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id             = "vpc-00000000000000000"
    private_subnet_ids = ["subnet-aaa", "subnet-bbb", "subnet-ccc"]
    public_subnet_ids  = ["subnet-ddd", "subnet-eee", "subnet-fff"]
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

inputs = {
  name            = "testing"
  cluster_version = "1.28"

  vpc_id             = dependency.vpc.outputs.vpc_id
  private_subnet_ids = dependency.vpc.outputs.private_subnet_ids
  public_subnet_ids  = dependency.vpc.outputs.public_subnet_ids

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false

  node_group_defaults = {
    instance_types = ["m6i.large"]
    capacity_type  = "ON_DEMAND"
    disk_size      = 50
  }

  node_groups = {
    general = {
      desired_size   = 1
      min_size       = 1
      max_size       = 1
      instance_types = ["m6i.large"]
      labels = {
        workload = "general"
        team     = "platform"
      }
    }
  }

  enable_cluster_encryption  = true
  cluster_log_types          = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  cluster_log_retention_days = 90
}
