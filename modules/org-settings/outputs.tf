output "id" {
  description = "The ID of the organization settings"
  value       = github_organization_settings.this.id
}

output "settings" {
  description = "All organization settings attributes"
  value = {
    id                                                           = github_organization_settings.this.id
    name                                                         = github_organization_settings.this.name
    description                                                  = github_organization_settings.this.description
    company                                                      = github_organization_settings.this.company
    blog                                                         = github_organization_settings.this.blog
    email                                                        = github_organization_settings.this.email
    billing_email                                                = github_organization_settings.this.billing_email
    location                                                     = github_organization_settings.this.location
    default_repository_permission                                = github_organization_settings.this.default_repository_permission
    members_can_create_repositories                              = github_organization_settings.this.members_can_create_repositories
    members_can_create_public_repositories                       = github_organization_settings.this.members_can_create_public_repositories
    members_can_create_private_repositories                      = github_organization_settings.this.members_can_create_private_repositories
    members_can_create_internal_repositories                     = github_organization_settings.this.members_can_create_internal_repositories
    members_can_fork_private_repositories                        = github_organization_settings.this.members_can_fork_private_repositories
    web_commit_signoff_required                                  = github_organization_settings.this.web_commit_signoff_required
    dependabot_alerts_enabled_for_new_repositories               = github_organization_settings.this.dependabot_alerts_enabled_for_new_repositories
    dependabot_security_updates_enabled_for_new_repositories     = github_organization_settings.this.dependabot_security_updates_enabled_for_new_repositories
    dependency_graph_enabled_for_new_repositories                = github_organization_settings.this.dependency_graph_enabled_for_new_repositories
    secret_scanning_enabled_for_new_repositories                 = github_organization_settings.this.secret_scanning_enabled_for_new_repositories
    secret_scanning_push_protection_enabled_for_new_repositories = github_organization_settings.this.secret_scanning_push_protection_enabled_for_new_repositories
  }
}
