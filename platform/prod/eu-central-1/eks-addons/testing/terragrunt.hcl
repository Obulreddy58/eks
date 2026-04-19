# -----------------------------------------------------------------------------
# EKS Addons for testing — Auto-generated
# Jira: INFRA-3003
# Operators: ArgoCD, ALB Controller, Karpenter, ESO, cert-manager
# -----------------------------------------------------------------------------

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/Obulreddy58/keystone-modules.git//eks-addons?ref=main"
}

generate "helm_provider" {
  path      = "helm_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    data "aws_eks_cluster_auth" "this" {
      name = var.cluster_name
    }

    provider "helm" {
      kubernetes {
        host                   = var.cluster_endpoint
        cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)
        token                  = data.aws_eks_cluster_auth.this.token
      }
    }

    provider "kubectl" {
      host                   = var.cluster_endpoint
      cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)
      token                  = data.aws_eks_cluster_auth.this.token
      load_config_file       = false
    }
  EOF
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id = "vpc-00000000000000000"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

dependency "eks" {
  config_path = "../eks"

  mock_outputs = {
    cluster_name                       = "testing"
    cluster_endpoint                   = "https://XXXXXX.gr7.eu-central-1.eks.amazonaws.com"
    cluster_certificate_authority_data = "dGVzdA=="
    oidc_provider_arn                  = "arn:aws:iam::751106206844:oidc-provider/oidc.eks.eu-central-1.amazonaws.com/id/XXXXXX"
    oidc_provider_url                  = "oidc.eks.eu-central-1.amazonaws.com/id/XXXXXX"
    node_group_role_arn                = "arn:aws:iam::751106206844:role/testing-node"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

inputs = {
  cluster_name                       = dependency.eks.outputs.cluster_name
  cluster_endpoint                   = dependency.eks.outputs.cluster_endpoint
  cluster_certificate_authority_data = dependency.eks.outputs.cluster_certificate_authority_data
  oidc_provider_arn                  = dependency.eks.outputs.oidc_provider_arn
  oidc_provider_url                  = dependency.eks.outputs.oidc_provider_url
  vpc_id                             = dependency.vpc.outputs.vpc_id
  aws_region                         = "eu-central-1"

  # ── Operators ──────────────────────────────────────────────────────────────
  enable_argocd                       = true
  enable_aws_load_balancer_controller = true
  enable_karpenter                    = true
  enable_external_secrets             = true
  enable_cert_manager                 = true
  enable_metrics_server               = true
  enable_external_dns                 = false

  karpenter_node_role_arn = dependency.eks.outputs.node_group_role_arn
}
