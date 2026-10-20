include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/ruleset"
}

dependency "teams" {
  config_path = "../teams"

  mock_outputs = {
    teams = {
      "platform-engineering" = {
        id      = "1001"
        node_id = "T_1001"
        slug    = "platform-engineering"
        name    = "platform-engineering"
      }
    }
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

inputs = {
  repository           = null
  include_repositories = ["~ALL"]
  bypass_team_ids      = [dependency.teams.outputs.teams["platform-engineering"].id]
  block_force_push     = null
}
