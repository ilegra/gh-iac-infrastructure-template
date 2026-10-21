include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/org-settings"
}

locals {
  org_owner = coalesce(get_env("GITHUB_OWNER", ""), get_env("GITHUB_ORG", ""), get_env("ORG_OWNER", ""))
}

inputs = {
  billing_email                                                = try(coalesce(get_env("GITHUB_BILLING_EMAIL", ""), get_env("ORG_BILLING_EMAIL", "")), null)
  email                                                        = try(coalesce(get_env("GITHUB_EMAIL", ""), get_env("ORG_EMAIL", "")), null)
  name                                                         = try(coalesce(get_env("GITHUB_ORG_NAME", ""), get_env("ORG_NAME", "")), local.org_owner)
  company                                                      = try(coalesce(get_env("GITHUB_COMPANY", ""), get_env("ORG_COMPANY", "")), local.org_owner)
  description                                                  = try(coalesce(get_env("GITHUB_DESCRIPTION", ""), get_env("ORG_DESCRIPTION", "")), null)
  location                                                     = try(coalesce(get_env("GITHUB_LOCATION", ""), get_env("ORG_LOCATION", "")), null)
  blog                                                         = try(coalesce(get_env("GITHUB_BLOG", ""), get_env("ORG_BLOG", "")), null)
  default_repository_permission                                = "read"
  members_can_create_repositories                              = true
  members_can_create_public_repositories                       = true
  members_can_create_private_repositories                      = true
  members_can_create_internal_repositories                     = false
  members_can_fork_private_repositories                        = true
  web_commit_signoff_required                                  = true
  dependabot_alerts_enabled_for_new_repositories               = true
  dependabot_security_updates_enabled_for_new_repositories     = true
  dependency_graph_enabled_for_new_repositories                = true
  secret_scanning_enabled_for_new_repositories                 = true
  secret_scanning_push_protection_enabled_for_new_repositories = true
}
