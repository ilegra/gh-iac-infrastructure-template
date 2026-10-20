include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//org/repositories/group-2"
}

dependency "teams" {
  config_path = "../../teams"

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
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
}

inputs = {
  teams = dependency.teams.outputs.teams
}
