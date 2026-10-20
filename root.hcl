locals {
  github_owner               = get_env("ORG_OWNER")
  github_app_id              = get_env("INFRA_APP_ID")
  github_app_installation_id = get_env("INFRA_APP_INSTALATION_ID")
}

remote_state {
  backend = "local"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    path = "${get_parent_terragrunt_dir()}/.terragrunt-state/${path_relative_to_include()}/terraform.tfstate"
  }
}

generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  required_version = ">= 1.16.0"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}
EOF
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "github" {
  owner = "${local.github_owner}"

  app_auth {
    id              = "${local.github_app_id}"
    installation_id = "${local.github_app_installation_id}"
    pem_file        = file("${get_repo_root()}/github-app-private-key.pem")
  }
}
EOF
}
