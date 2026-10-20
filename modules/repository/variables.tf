variable "name" {
  description = "The name of the repository"
  type        = string
}

variable "description" {
  description = "A description of the repository"
  type        = string
  default     = null
}

variable "visibility" {
  description = "Can be public, private, or internal"
  type        = string
  default     = "private"
}

variable "default_branch" {
  description = "The default branch of the repository"
  type        = string
  default     = "main"
}

variable "auto_init" {
  description = "Produce an initial commit in the repository"
  type        = bool
  default     = true
}

variable "archive_on_destroy" {
  description = "Set to true to archive the repository instead of deleting on destroy"
  type        = bool
  default     = true
}

variable "has_issues" {
  description = "Enable GitHub Issues features on the repository"
  type        = bool
  default     = true
}

variable "has_projects" {
  description = "Enable GitHub Projects features on the repository"
  type        = bool
  default     = false
}

variable "has_wiki" {
  description = "Enable GitHub Wiki features on the repository"
  type        = bool
  default     = false
}

variable "has_discussions" {
  description = "Enable GitHub Discussions features on the repository"
  type        = bool
  default     = false
}

variable "is_template" {
  description = "Whether this repository is a template"
  type        = bool
  default     = false
}

variable "allow_merge_commit" {
  description = "Allow merge commits"
  type        = bool
  default     = false
}

variable "allow_squash_merge" {
  description = "Allow squash merges"
  type        = bool
  default     = true
}

variable "allow_rebase_merge" {
  description = "Allow rebase merges"
  type        = bool
  default     = false
}

variable "allow_auto_merge" {
  description = "Allow auto-merge on pull requests"
  type        = bool
  default     = true
}

variable "delete_branch_on_merge" {
  description = "Automatically delete head branches after pull requests are merged"
  type        = bool
  default     = true
}

variable "vulnerability_alerts" {
  description = "Set to true to enable security alerts for vulnerable dependencies"
  type        = bool
  default     = true
}

variable "topics" {
  description = "List of topics for the repository"
  type        = list(string)
  default     = []
}

variable "team_permissions" {
  description = "Map of team slug to permission (pull, triage, push, maintain, admin)"
  type        = map(string)
  default     = {}
}

variable "environments" {
  description = "Map of deployment environments to configure"
  type = map(object({
    wait_timer          = optional(number, 0)
    can_admins_bypass   = optional(bool, false)
    prevent_self_review = optional(bool, true)
    reviewer_team_ids   = optional(list(string), [])
    reviewer_user_ids   = optional(list(string), [])
    branch_patterns     = optional(list(string), [])
    variables           = optional(map(string), {})
  }))
  default = {}
}

variable "actions_variables" {
  description = "Map of repository-level GitHub Actions variables"
  type        = map(string)
  default     = {}
}
