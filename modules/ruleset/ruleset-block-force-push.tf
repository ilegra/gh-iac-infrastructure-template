locals {
  block_force_push_enabled = var.block_force_push != null
  block_force_push_bypass  = local.block_force_push_enabled ? distinct(concat(var.bypass_team_ids, var.block_force_push.bypass_team_ids)) : []
}

resource "github_organization_ruleset" "block_force_push" {
  count = local.block_force_push_enabled && var.repository == null ? 1 : 0

  name        = var.block_force_push.name
  target      = "branch"
  enforcement = var.block_force_push.enforcement

  conditions {
    ref_name {
      include = var.block_force_push.branches
      exclude = var.block_force_push.exclude_branches
    }
    repository_name {
      include = var.include_repositories
      exclude = var.exclude_repositories
    }
  }

  dynamic "bypass_actors" {
    for_each = local.block_force_push_bypass
    content {
      actor_id    = tonumber(bypass_actors.value)
      actor_type  = "Team"
      bypass_mode = "always"
    }
  }

  rules {
    non_fast_forward = true
  }
}

resource "github_repository_ruleset" "block_force_push" {
  count = local.block_force_push_enabled && var.repository != null ? 1 : 0

  name        = var.block_force_push.name
  repository  = var.repository
  target      = "branch"
  enforcement = var.block_force_push.enforcement

  conditions {
    ref_name {
      include = var.block_force_push.branches
      exclude = var.block_force_push.exclude_branches
    }
  }

  dynamic "bypass_actors" {
    for_each = local.block_force_push_bypass
    content {
      actor_id    = tonumber(bypass_actors.value)
      actor_type  = "Team"
      bypass_mode = "always"
    }
  }

  rules {
    non_fast_forward = true
  }
}
