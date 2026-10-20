variable "repository" {
  description = "Target repository name. If null, creates organization-level rulesets (github_organization_ruleset). If set, creates repository-level rulesets (github_repository_ruleset)."
  type        = string
  default     = null
}

variable "include_repositories" {
  description = "Repository name patterns to include for organization rulesets (e.g. ['~ALL'] or ['repo-prefix*'])"
  type        = list(string)
  default     = ["~ALL"]
}

variable "exclude_repositories" {
  description = "Repository name patterns to exclude for organization rulesets"
  type        = list(string)
  default     = []
}

variable "bypass_team_ids" {
  description = "List of Team IDs allowed to bypass rulesets by default"
  type        = list(string)
  default     = []
}

variable "block_force_push" {
  description = "Configure the block-force-push ruleset. Pass {} for defaults or null to disable."
  type = object({
    name             = optional(string, "block-force-push")
    enforcement      = optional(string, "active")
    branches         = optional(list(string), ["~DEFAULT_BRANCH"])
    exclude_branches = optional(list(string), [])
    bypass_team_ids  = optional(list(string), [])
  })
  default = null
}

variable "prevent_branch_deletion" {
  description = "Configure the prevent-branch-deletion ruleset. Pass {} for defaults or null to disable."
  type = object({
    name             = optional(string, "prevent-branch-deletion")
    enforcement      = optional(string, "active")
    branches         = optional(list(string), ["~DEFAULT_BRANCH"])
    exclude_branches = optional(list(string), [])
    bypass_team_ids  = optional(list(string), [])
  })
  default = null
}

variable "require_pull_request" {
  description = "Configure the require-pull-request ruleset. Pass {} for defaults or null to disable."
  type = object({
    name                              = optional(string, "require-pull-request")
    enforcement                       = optional(string, "active")
    branches                          = optional(list(string), ["~DEFAULT_BRANCH"])
    exclude_branches                  = optional(list(string), [])
    required_approving_review_count   = optional(number, 1)
    dismiss_stale_reviews_on_push     = optional(bool, true)
    require_code_owner_review         = optional(bool, true)
    require_last_push_approval        = optional(bool, false)
    required_review_thread_resolution = optional(bool, true)
    bypass_team_ids                   = optional(list(string), [])
  })
  default = null
}

variable "require_status_checks" {
  description = "Configure the require-status-checks ruleset. Pass {} for defaults or null to disable."
  type = object({
    name                                 = optional(string, "require-status-checks")
    enforcement                          = optional(string, "active")
    branches                             = optional(list(string), ["~DEFAULT_BRANCH"])
    exclude_branches                     = optional(list(string), [])
    strict_required_status_checks_policy = optional(bool, true)
    contexts                             = optional(list(string), [])
    bypass_team_ids                      = optional(list(string), [])
  })
  default = null
}

variable "protect_tags" {
  description = "Configure the protect-tags ruleset. Pass {} for defaults or null to disable."
  type = object({
    name            = optional(string, "protect-tags")
    enforcement     = optional(string, "active")
    tags            = optional(list(string), ["refs/tags/v*"])
    exclude_tags    = optional(list(string), [])
    bypass_team_ids = optional(list(string), [])
  })
  default = null
}
