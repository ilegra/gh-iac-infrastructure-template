variable "name" {
  description = "The name of the organization"
  type        = string
  default     = null
}

variable "description" {
  description = "The description of the organization"
  type        = string
  default     = null
}

variable "company" {
  description = "The company name"
  type        = string
  default     = null
}

variable "blog" {
  description = "The blog or website URL"
  type        = string
  default     = null
}

variable "email" {
  description = "The publicly visible email address"
  type        = string
  default     = null
}

variable "billing_email" {
  description = "The billing email address"
  type        = string
  default     = null
}

variable "location" {
  description = "The location of the organization"
  type        = string
  default     = null
}

variable "default_repository_permission" {
  description = "The default permission for organization members on repositories (read, write, admin, none)"
  type        = string
  default     = "read"
}

variable "members_can_create_repositories" {
  description = "Whether members can create repositories"
  type        = bool
  default     = true
}

variable "members_can_create_public_repositories" {
  description = "Whether members can create public repositories"
  type        = bool
  default     = false
}

variable "members_can_create_private_repositories" {
  description = "Whether members can create private repositories"
  type        = bool
  default     = true
}

variable "members_can_create_internal_repositories" {
  description = "Whether members can create internal repositories"
  type        = bool
  default     = true
}

variable "members_can_fork_private_repositories" {
  description = "Whether members can fork private repositories"
  type        = bool
  default     = false
}

variable "web_commit_signoff_required" {
  description = "Whether web commit signoff is required"
  type        = bool
  default     = true
}

variable "dependabot_alerts_enabled_for_new_repositories" {
  description = "Whether Dependabot alerts are enabled for new repositories"
  type        = bool
  default     = true
}

variable "dependabot_security_updates_enabled_for_new_repositories" {
  description = "Whether Dependabot security updates are enabled for new repositories"
  type        = bool
  default     = true
}

variable "dependency_graph_enabled_for_new_repositories" {
  description = "Whether dependency graph is enabled for new repositories"
  type        = bool
  default     = true
}

variable "secret_scanning_enabled_for_new_repositories" {
  description = "Whether secret scanning is enabled for new repositories"
  type        = bool
  default     = true
}

variable "secret_scanning_push_protection_enabled_for_new_repositories" {
  description = "Whether secret scanning push protection is enabled for new repositories"
  type        = bool
  default     = true
}
