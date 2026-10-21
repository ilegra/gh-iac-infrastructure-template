locals {
  github_owner               = coalesce(get_env("GITHUB_OWNER", ""), get_env("GITHUB_ORG", ""), get_env("ORG_OWNER", ""))
  github_app_id              = coalesce(get_env("GITHUB_APP_ID", ""), get_env("INFRA_APP_ID", ""))
  github_app_installation_id = coalesce(get_env("GITHUB_APP_INSTALLATION_ID", ""), get_env("INFRA_APP_INSTALLATION_ID", ""), get_env("INFRA_APP_INSTALATION_ID", ""))
}

remote_state {
  backend = "local"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    path = "${get_repo_root()}/.terragrunt-state/${path_relative_to_include()}/terraform.tfstate"
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
