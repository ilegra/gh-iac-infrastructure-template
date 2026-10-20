locals {
  require_pull_request_enabled = var.require_pull_request != null
  require_pull_request_bypass  = local.require_pull_request_enabled ? distinct(concat(var.bypass_team_ids, var.require_pull_request.bypass_team_ids)) : []
}

resource "github_organization_ruleset" "require_pull_request" {
  count = local.require_pull_request_enabled && var.repository == null ? 1 : 0

  name        = var.require_pull_request.name
  target      = "branch"
  enforcement = var.require_pull_request.enforcement

  conditions {
    ref_name {
      include = var.require_pull_request.branches
      exclude = var.require_pull_request.exclude_branches
    }
    repository_name {
      include = var.include_repositories
      exclude = var.exclude_repositories
    }
  }

  dynamic "bypass_actors" {
    for_each = local.require_pull_request_bypass
    content {
      actor_id    = tonumber(bypass_actors.value)
      actor_type  = "Team"
      bypass_mode = "always"
    }
  }

  rules {
    pull_request {
      required_approving_review_count   = var.require_pull_request.required_approving_review_count
      dismiss_stale_reviews_on_push     = var.require_pull_request.dismiss_stale_reviews_on_push
      require_code_owner_review         = var.require_pull_request.require_code_owner_review
      require_last_push_approval        = var.require_pull_request.require_last_push_approval
      required_review_thread_resolution = var.require_pull_request.required_review_thread_resolution
    }
  }
}

resource "github_repository_ruleset" "require_pull_request" {
  count = local.require_pull_request_enabled && var.repository != null ? 1 : 0

  name        = var.require_pull_request.name
  repository  = var.repository
  target      = "branch"
  enforcement = var.require_pull_request.enforcement

  conditions {
    ref_name {
      include = var.require_pull_request.branches
      exclude = var.require_pull_request.exclude_branches
    }
  }

  dynamic "bypass_actors" {
    for_each = local.require_pull_request_bypass
    content {
      actor_id    = tonumber(bypass_actors.value)
      actor_type  = "Team"
      bypass_mode = "always"
    }
  }

  rules {
    pull_request {
      required_approving_review_count   = var.require_pull_request.required_approving_review_count
      dismiss_stale_reviews_on_push     = var.require_pull_request.dismiss_stale_reviews_on_push
      require_code_owner_review         = var.require_pull_request.require_code_owner_review
      require_last_push_approval        = var.require_pull_request.require_last_push_approval
      required_review_thread_resolution = var.require_pull_request.required_review_thread_resolution
    }
  }
}
