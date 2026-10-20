include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/org-settings"
}

inputs = {
  billing_email                                                = "contato@ilegra.com"
  email                                                        = "contato@ilegra.com"
  name                                                         = "ilegra"
  company                                                      = "ilegra"
  description                                                  = "Think Beyond!"
  location                                                     = "Porto Alegre - Brazil"
  blog                                                         = "https://ilegra.com"
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
