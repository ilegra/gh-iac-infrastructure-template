output "rulesets" {
  description = "Detailed map of provisioned rulesets"
  value = {
    block_force_push = {
      org = length(github_organization_ruleset.block_force_push) > 0 ? {
        id          = github_organization_ruleset.block_force_push[0].id
        node_id     = github_organization_ruleset.block_force_push[0].node_id
        ruleset_id  = github_organization_ruleset.block_force_push[0].ruleset_id
        etag        = github_organization_ruleset.block_force_push[0].etag
        enforcement = github_organization_ruleset.block_force_push[0].enforcement
        target      = github_organization_ruleset.block_force_push[0].target
      } : null
      repo = length(github_repository_ruleset.block_force_push) > 0 ? {
        id          = github_repository_ruleset.block_force_push[0].id
        node_id     = github_repository_ruleset.block_force_push[0].node_id
        ruleset_id  = github_repository_ruleset.block_force_push[0].ruleset_id
        etag        = github_repository_ruleset.block_force_push[0].etag
        enforcement = github_repository_ruleset.block_force_push[0].enforcement
        target      = github_repository_ruleset.block_force_push[0].target
      } : null
    }
    prevent_branch_deletion = {
      org = length(github_organization_ruleset.prevent_branch_deletion) > 0 ? {
        id          = github_organization_ruleset.prevent_branch_deletion[0].id
        node_id     = github_organization_ruleset.prevent_branch_deletion[0].node_id
        ruleset_id  = github_organization_ruleset.prevent_branch_deletion[0].ruleset_id
        etag        = github_organization_ruleset.prevent_branch_deletion[0].etag
        enforcement = github_organization_ruleset.prevent_branch_deletion[0].enforcement
        target      = github_organization_ruleset.prevent_branch_deletion[0].target
      } : null
      repo = length(github_repository_ruleset.prevent_branch_deletion) > 0 ? {
        id          = github_repository_ruleset.prevent_branch_deletion[0].id
        node_id     = github_repository_ruleset.prevent_branch_deletion[0].node_id
        ruleset_id  = github_repository_ruleset.prevent_branch_deletion[0].ruleset_id
        etag        = github_repository_ruleset.prevent_branch_deletion[0].etag
        enforcement = github_repository_ruleset.prevent_branch_deletion[0].enforcement
        target      = github_repository_ruleset.prevent_branch_deletion[0].target
      } : null
    }
    require_pull_request = {
      org = length(github_organization_ruleset.require_pull_request) > 0 ? {
        id          = github_organization_ruleset.require_pull_request[0].id
        node_id     = github_organization_ruleset.require_pull_request[0].node_id
        ruleset_id  = github_organization_ruleset.require_pull_request[0].ruleset_id
        etag        = github_organization_ruleset.require_pull_request[0].etag
        enforcement = github_organization_ruleset.require_pull_request[0].enforcement
        target      = github_organization_ruleset.require_pull_request[0].target
      } : null
      repo = length(github_repository_ruleset.require_pull_request) > 0 ? {
        id          = github_repository_ruleset.require_pull_request[0].id
        node_id     = github_repository_ruleset.require_pull_request[0].node_id
        ruleset_id  = github_repository_ruleset.require_pull_request[0].ruleset_id
        etag        = github_repository_ruleset.require_pull_request[0].etag
        enforcement = github_repository_ruleset.require_pull_request[0].enforcement
        target      = github_repository_ruleset.require_pull_request[0].target
      } : null
    }
    require_status_checks = {
      org = length(github_organization_ruleset.require_status_checks) > 0 ? {
        id          = github_organization_ruleset.require_status_checks[0].id
        node_id     = github_organization_ruleset.require_status_checks[0].node_id
        ruleset_id  = github_organization_ruleset.require_status_checks[0].ruleset_id
        etag        = github_organization_ruleset.require_status_checks[0].etag
        enforcement = github_organization_ruleset.require_status_checks[0].enforcement
        target      = github_organization_ruleset.require_status_checks[0].target
      } : null
      repo = length(github_repository_ruleset.require_status_checks) > 0 ? {
        id          = github_repository_ruleset.require_status_checks[0].id
        node_id     = github_repository_ruleset.require_status_checks[0].node_id
        ruleset_id  = github_repository_ruleset.require_status_checks[0].ruleset_id
        etag        = github_repository_ruleset.require_status_checks[0].etag
        enforcement = github_repository_ruleset.require_status_checks[0].enforcement
        target      = github_repository_ruleset.require_status_checks[0].target
      } : null
    }
    protect_tags = {
      org = length(github_organization_ruleset.protect_tags) > 0 ? {
        id          = github_organization_ruleset.protect_tags[0].id
        node_id     = github_organization_ruleset.protect_tags[0].node_id
        ruleset_id  = github_organization_ruleset.protect_tags[0].ruleset_id
        etag        = github_organization_ruleset.protect_tags[0].etag
        enforcement = github_organization_ruleset.protect_tags[0].enforcement
        target      = github_organization_ruleset.protect_tags[0].target
      } : null
      repo = length(github_repository_ruleset.protect_tags) > 0 ? {
        id          = github_repository_ruleset.protect_tags[0].id
        node_id     = github_repository_ruleset.protect_tags[0].node_id
        ruleset_id  = github_repository_ruleset.protect_tags[0].ruleset_id
        etag        = github_repository_ruleset.protect_tags[0].etag
        enforcement = github_repository_ruleset.protect_tags[0].enforcement
        target      = github_repository_ruleset.protect_tags[0].target
      } : null
    }
  }
}
