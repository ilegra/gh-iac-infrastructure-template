resource "github_repository" "this" {
  name                   = var.name
  description            = var.description
  visibility             = var.visibility
  has_issues             = var.has_issues
  has_discussions        = var.has_discussions
  has_projects           = var.has_projects
  has_wiki               = var.has_wiki
  is_template            = var.is_template
  allow_merge_commit     = var.allow_merge_commit
  allow_squash_merge     = var.allow_squash_merge
  allow_rebase_merge     = var.allow_rebase_merge
  allow_auto_merge       = var.allow_auto_merge
  delete_branch_on_merge = var.delete_branch_on_merge
  auto_init              = var.auto_init
  archive_on_destroy     = var.archive_on_destroy
  vulnerability_alerts   = var.vulnerability_alerts
  topics                 = var.topics
}

resource "github_branch_default" "this" {
  count      = var.default_branch != null ? 1 : 0
  repository = github_repository.this.name
  branch     = var.default_branch
}

resource "github_team_repository" "this" {
  for_each = var.team_permissions

  repository = github_repository.this.name
  team_id    = each.key
  permission = each.value
}

resource "github_repository_environment" "this" {
  for_each = var.environments

  repository          = github_repository.this.name
  environment         = each.key
  wait_timer          = each.value.wait_timer
  can_admins_bypass   = each.value.can_admins_bypass
  prevent_self_review = each.value.prevent_self_review

  dynamic "reviewers" {
    for_each = length(each.value.reviewer_team_ids) > 0 || length(each.value.reviewer_user_ids) > 0 ? [1] : []
    content {
      teams = [for id in each.value.reviewer_team_ids : tonumber(id)]
      users = [for id in each.value.reviewer_user_ids : tonumber(id)]
    }
  }

  dynamic "deployment_branch_policy" {
    for_each = length(each.value.branch_patterns) > 0 ? [1] : []
    content {
      protected_branches     = false
      custom_branch_policies = true
    }
  }
}

locals {
  env_branch_policies = flatten([
    for env_name, env_cfg in var.environments : [
      for pattern in env_cfg.branch_patterns : {
        environment = env_name
        pattern     = pattern
      }
    ]
  ])

  env_variables = flatten([
    for env_name, env_cfg in var.environments : [
      for var_name, var_val in env_cfg.variables : {
        environment   = env_name
        variable_name = var_name
        value         = var_val
      }
    ]
  ])
}

resource "github_repository_environment_deployment_policy" "this" {
  for_each = {
    for p in local.env_branch_policies : "${p.environment}-${p.pattern}" => p
  }

  repository     = github_repository.this.name
  environment    = github_repository_environment.this[each.value.environment].environment
  branch_pattern = each.value.pattern
}

resource "github_actions_environment_variable" "this" {
  for_each = {
    for v in local.env_variables : "${v.environment}-${v.variable_name}" => v
  }

  repository    = github_repository.this.name
  environment   = github_repository_environment.this[each.value.environment].environment
  variable_name = each.value.variable_name
  value         = each.value.value
}

resource "github_actions_variable" "this" {
  for_each = var.actions_variables

  repository    = github_repository.this.name
  variable_name = each.key
  value         = each.value
}
