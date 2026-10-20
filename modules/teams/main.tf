resource "github_team" "this" {
  for_each = var.teams

  name           = each.key
  description    = each.value.description
  privacy        = each.value.privacy
  parent_team_id = each.value.parent_team_id
}

resource "github_team_members" "this" {
  for_each = {
    for k, v in var.teams : k => v
    if length(v.members) > 0
  }

  team_id = github_team.this[each.key].id

  dynamic "members" {
    for_each = each.value.members
    content {
      username = members.value.username
      role     = members.value.role
    }
  }
}
