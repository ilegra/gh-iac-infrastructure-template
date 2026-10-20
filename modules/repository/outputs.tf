output "name" {
  description = "The name of the repository"
  value       = github_repository.this.name
}

output "full_name" {
  description = "The full name (org/repo) of the repository"
  value       = github_repository.this.full_name
}

output "html_url" {
  description = "URL to the repository on GitHub"
  value       = github_repository.this.html_url
}

output "ssh_clone_url" {
  description = "URL that can be provided to git clone via SSH"
  value       = github_repository.this.ssh_clone_url
}

output "http_clone_url" {
  description = "URL that can be provided to git clone via HTTPS"
  value       = github_repository.this.http_clone_url
}

output "git_clone_url" {
  description = "Git clone URL"
  value       = github_repository.this.git_clone_url
}

output "svn_url" {
  description = "SVN clone URL"
  value       = github_repository.this.svn_url
}

output "node_id" {
  description = "GraphQL global node id for the repository"
  value       = github_repository.this.node_id
}

output "repo_id" {
  description = "GitHub ID for the repository"
  value       = github_repository.this.repo_id
}

output "default_branch" {
  description = "The default branch of the repository"
  value       = var.default_branch
}

output "visibility" {
  description = "The visibility of the repository"
  value       = github_repository.this.visibility
}

output "topics" {
  description = "The topics assigned to the repository"
  value       = github_repository.this.topics
}

output "team_permissions" {
  description = "Map of team permissions configured for the repository"
  value = {
    for k, v in github_team_repository.this : k => {
      id         = v.id
      team_id    = v.team_id
      permission = v.permission
      etag       = v.etag
    }
  }
}

output "environments" {
  description = "Map of environments configured for the repository"
  value = {
    for k, v in github_repository_environment.this : k => {
      environment = v.environment
      wait_timer  = v.wait_timer
    }
  }
}

output "actions_variables" {
  description = "Map of repository-level Actions variables"
  value = {
    for k, v in github_actions_variable.this : k => {
      variable_name = v.variable_name
      value         = v.value
      created_at    = v.created_at
      updated_at    = v.updated_at
    }
  }
}

output "environment_variables" {
  description = "Map of environment-level Actions variables"
  value = {
    for k, v in github_actions_environment_variable.this : k => {
      environment   = v.environment
      variable_name = v.variable_name
      value         = v.value
      created_at    = v.created_at
      updated_at    = v.updated_at
    }
  }
}
