include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//org/repositories/group-1"
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
      "backend-developers" = {
        id      = "1002"
        node_id = "T_1002"
        slug    = "backend-developers"
        name    = "backend-developers"
      }
      "security" = {
        id      = "1003"
        node_id = "T_1003"
        slug    = "security"
        name    = "security"
      }
    }
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
}

dependencies {
  paths = ["../../settings", "../../rulesets"]
}

inputs = {
  teams = dependency.teams.outputs.teams
}
