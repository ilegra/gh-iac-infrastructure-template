locals {
  protect_tags_enabled = var.protect_tags != null
  protect_tags_bypass  = local.protect_tags_enabled ? distinct(concat(var.bypass_team_ids, var.protect_tags.bypass_team_ids)) : []
}

resource "github_organization_ruleset" "protect_tags" {
  count = local.protect_tags_enabled && var.repository == null ? 1 : 0

  name        = var.protect_tags.name
  target      = "tag"
  enforcement = var.protect_tags.enforcement

  conditions {
    ref_name {
      include = var.protect_tags.tags
      exclude = var.protect_tags.exclude_tags
    }
    repository_name {
      include = var.include_repositories
      exclude = var.exclude_repositories
    }
  }

  dynamic "bypass_actors" {
    for_each = local.protect_tags_bypass
    content {
      actor_id    = tonumber(bypass_actors.value)
      actor_type  = "Team"
      bypass_mode = "always"
    }
  }

  rules {
    creation         = false
    update           = true
    deletion         = true
    non_fast_forward = true
  }
}

resource "github_repository_ruleset" "protect_tags" {
  count = local.protect_tags_enabled && var.repository != null ? 1 : 0

  name        = var.protect_tags.name
  repository  = var.repository
  target      = "tag"
  enforcement = var.protect_tags.enforcement

  conditions {
    ref_name {
      include = var.protect_tags.tags
      exclude = var.protect_tags.exclude_tags
    }
  }

  dynamic "bypass_actors" {
    for_each = local.protect_tags_bypass
    content {
      actor_id    = tonumber(bypass_actors.value)
      actor_type  = "Team"
      bypass_mode = "always"
    }
  }

  rules {
    creation         = false
    update           = true
    deletion         = true
    non_fast_forward = true
  }
}
