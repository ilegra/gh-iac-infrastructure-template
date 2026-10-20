include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/teams"
}

inputs = {
  teams = {
    platform-engineering = {
      description = "Platform and Cloud Engineering team"
      privacy     = "closed"
      members     = []
    }
    backend-developers = {
      description = "Backend software engineering team"
      privacy     = "closed"
      members     = []
    }
    frontend-developers = {
      description = "Frontend software engineering team"
      privacy     = "closed"
      members     = []
    }
    security = {
      description = "Information security and compliance team"
      privacy     = "closed"
      members     = []
    }
  }
}
