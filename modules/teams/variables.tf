variable "teams" {
  description = "Map of teams to provision"
  type = map(object({
    description    = optional(string, null)
    privacy        = optional(string, "closed")
    parent_team_id = optional(number, null)
    members = optional(list(object({
      username = string
      role     = optional(string, "member")
    })), [])
  }))
  default = {}
}
