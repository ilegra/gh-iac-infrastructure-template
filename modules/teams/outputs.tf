output "teams" {
  description = "Map of created team attributes"
  value = {
    for k, t in github_team.this : k => {
      id             = t.id
      node_id        = t.node_id
      slug           = t.slug
      name           = t.name
      description    = t.description
      privacy        = t.privacy
      parent_team_id = t.parent_team_id
      etag           = t.etag
      members_count  = t.members_count
    }
  }
}

output "team_ids" {
  description = "Map of team key to team ID"
  value = {
    for k, t in github_team.this : k => t.id
  }
}

output "team_slugs" {
  description = "Map of team key to team slug"
  value = {
    for k, t in github_team.this : k => t.slug
  }
}
