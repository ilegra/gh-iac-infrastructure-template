locals {
  prevent_branch_deletion_enabled = var.prevent_branch_deletion != null
  prevent_branch_deletion_bypass  = local.prevent_branch_deletion_enabled ? distinct(concat(var.bypass_team_ids, var.prevent_branch_deletion.bypass_team_ids)) : []
}

resource "github_organization_ruleset" "prevent_branch_deletion" {
  count = local.prevent_branch_deletion_enabled && var.repository == null ? 1 : 0

  name        = var.prevent_branch_deletion.name
  target      = "branch"
  enforcement = var.prevent_branch_deletion.enforcement

  conditions {
    ref_name {
      include = var.prevent_branch_deletion.branches
      exclude = var.prevent_branch_deletion.exclude_branches
    }
    repository_name {
      include = var.include_repositories
      exclude = var.exclude_repositories
    }
  }

  dynamic "bypass_actors" {
    for_each = local.prevent_branch_deletion_bypass
    content {
      actor_id    = tonumber(bypass_actors.value)
      actor_type  = "Team"
      bypass_mode = "always"
    }
  }

  rules {
    deletion = true
  }
}

resource "github_repository_ruleset" "prevent_branch_deletion" {
  count = local.prevent_branch_deletion_enabled && var.repository != null ? 1 : 0

  name        = var.prevent_branch_deletion.name
  repository  = var.repository
  target      = "branch"
  enforcement = var.prevent_branch_deletion.enforcement

  conditions {
    ref_name {
      include = var.prevent_branch_deletion.branches
      exclude = var.prevent_branch_deletion.exclude_branches
    }
  }

  dynamic "bypass_actors" {
    for_each = local.prevent_branch_deletion_bypass
    content {
      actor_id    = tonumber(bypass_actors.value)
      actor_type  = "Team"
      bypass_mode = "always"
    }
  }

  rules {
    deletion = true
  }
}
