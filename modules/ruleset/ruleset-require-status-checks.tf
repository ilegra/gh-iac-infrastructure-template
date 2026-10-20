locals {
  require_status_checks_enabled = var.require_status_checks != null
  require_status_checks_bypass  = local.require_status_checks_enabled ? distinct(concat(var.bypass_team_ids, var.require_status_checks.bypass_team_ids)) : []
}

resource "github_organization_ruleset" "require_status_checks" {
  count = local.require_status_checks_enabled && var.repository == null ? 1 : 0

  name        = var.require_status_checks.name
  target      = "branch"
  enforcement = var.require_status_checks.enforcement

  conditions {
    ref_name {
      include = var.require_status_checks.branches
      exclude = var.require_status_checks.exclude_branches
    }
    repository_name {
      include = var.include_repositories
      exclude = var.exclude_repositories
    }
  }

  dynamic "bypass_actors" {
    for_each = local.require_status_checks_bypass
    content {
      actor_id    = tonumber(bypass_actors.value)
      actor_type  = "Team"
      bypass_mode = "always"
    }
  }

  rules {
    required_status_checks {
      strict_required_status_checks_policy = var.require_status_checks.strict_required_status_checks_policy

      dynamic "required_check" {
        for_each = var.require_status_checks.contexts
        content {
          context = required_check.value
        }
      }
    }
  }
}

resource "github_repository_ruleset" "require_status_checks" {
  count = local.require_status_checks_enabled && var.repository != null ? 1 : 0

  name        = var.require_status_checks.name
  repository  = var.repository
  target      = "branch"
  enforcement = var.require_status_checks.enforcement

  conditions {
    ref_name {
      include = var.require_status_checks.branches
      exclude = var.require_status_checks.exclude_branches
    }
  }

  dynamic "bypass_actors" {
    for_each = local.require_status_checks_bypass
    content {
      actor_id    = tonumber(bypass_actors.value)
      actor_type  = "Team"
      bypass_mode = "always"
    }
  }

  rules {
    required_status_checks {
      strict_required_status_checks_policy = var.require_status_checks.strict_required_status_checks_policy

      dynamic "required_check" {
        for_each = var.require_status_checks.contexts
        content {
          context = required_check.value
        }
      }
    }
  }
}
