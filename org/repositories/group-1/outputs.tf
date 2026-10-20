output "repositories" {
  description = "Detailed map of repositories configured in group-1"
  value = {
    sample_service = {
      name             = module.sample_service.name
      full_name        = module.sample_service.full_name
      html_url         = module.sample_service.html_url
      ssh_clone_url    = module.sample_service.ssh_clone_url
      http_clone_url   = module.sample_service.http_clone_url
      git_clone_url    = module.sample_service.git_clone_url
      node_id          = module.sample_service.node_id
      repo_id          = module.sample_service.repo_id
      default_branch   = module.sample_service.default_branch
      visibility       = module.sample_service.visibility
      team_permissions = module.sample_service.team_permissions
      environments     = module.sample_service.environments
      rulesets         = module.sample_service_rulesets.rulesets
    }
  }
}
