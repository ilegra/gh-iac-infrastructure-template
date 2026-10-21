module "sample_service" {
  source = "../../../modules/repository"

  name                   = "sample-service"
  description            = "Sample microservice repository"
  visibility             = "public"
  default_branch         = "main"
  delete_branch_on_merge = true
  vulnerability_alerts   = true
  topics                 = ["microservice", "sample", "backend"]

  team_permissions = {
    "platform-engineering" = "admin"
    "backend-developers"   = "push"
  }

  environments = {
    staging = {
      wait_timer        = 0
      can_admins_bypass = true
      branch_patterns   = ["main", "release/*"]
      variables = {
        LOG_LEVEL = "debug"
        ENV_NAME  = "staging"
      }
    }
    production = {
      wait_timer          = 0
      can_admins_bypass   = false
      prevent_self_review = true
      branch_patterns     = ["main"]
      variables = {
        LOG_LEVEL = "info"
        ENV_NAME  = "production"
      }
    }
  }
}

module "sample_service_rulesets" {
  source = "../../../modules/ruleset"

  repository      = module.sample_service.name
  bypass_team_ids = [try(var.teams["platform-engineering"].id, "1001")]

  block_force_push = {
    name     = "sample-service-block-force-push"
    branches = ["~DEFAULT_BRANCH", "refs/heads/release/*"]
  }

  prevent_branch_deletion = {
    name     = "sample-service-prevent-deletion"
    branches = ["~DEFAULT_BRANCH"]
  }
}
