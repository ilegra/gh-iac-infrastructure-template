# GitHub Infrastructure as Code Skeleton

Production-ready GitHub Infrastructure-as-Code (IaC) skeleton repository for the **ilegra** GitHub organization using **Terraform (>= 1.16.0)** with the [`integrations/github`](https://registry.terraform.io/providers/integrations/github/latest/docs) provider (~> 6.0) and **Terragrunt (>= 1.1.0)** for modular state isolation and orchestration.

---

## Architecture Overview

```
├── .gitignore
├── .terraform-version
├── github-app-private-key.pem      # Private key for GitHub App (ignored in git)
├── root.hcl                        # Root Terragrunt configuration (provider, backend, versions)
├── README.md
├── modules/                        # Reusable stateless Terraform modules
│   ├── org-settings/               # Organization-level settings module
│   ├── teams/                      # Organization teams and memberships module
│   ├── ruleset/                    # Unified ruleset module (org & repo scopes)
│   │   ├── versions.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── ruleset-block-force-push.tf
│   │   ├── ruleset-prevent-branch-deletion.tf
│   │   ├── ruleset-require-pull-request.tf
│   │   ├── ruleset-require-status-checks.tf
│   │   └── ruleset-protect-tags.tf
│   └── repository/                 # Repository, environments & access module
└── org/                            # Live Terragrunt state units
    ├── settings/                   # State unit for organization settings
    │   └── terragrunt.hcl
    ├── teams/                      # State unit for organization teams
    │   └── terragrunt.hcl
    ├── rulesets/                   # State unit for org-level rulesets
    │   └── terragrunt.hcl
    └── repositories/               # Repository groups (isolated state per group)
        ├── group-1/                # Group 1 state unit
        │   ├── terragrunt.hcl
        │   ├── variables.tf
        │   ├── outputs.tf
        │   └── repo-sample-service.tf
        └── group-2/                # Group 2 state unit
            ├── terragrunt.hcl
            └── variables.tf
```

---

## State Isolation Table

Every live unit has its own completely isolated Terraform state dynamically computed via `path_relative_to_include()`:

| Terragrunt Directory | State Scope | State Path (`local` backend) | Description |
| :--- | :--- | :--- | :--- |
| `org/settings` | Org Settings | `.terragrunt-state/org/settings/terraform.tfstate` | Org-level profile and security policies |
| `org/teams` | Org Teams | `.terragrunt-state/org/teams/terraform.tfstate` | Team definitions, hierarchies, memberships |
| `org/rulesets` | Org Rulesets | `.terragrunt-state/org/rulesets/terraform.tfstate` | Organization-wide rulesets (applied across all repos) |
| `org/repositories/group-1` | Group 1 Repos | `.terragrunt-state/org/repositories/group-1/terraform.tfstate` | All repository `.tf` files inside `group-1/` |
| `org/repositories/group-2` | Group 2 Repos | `.terragrunt-state/org/repositories/group-2/terraform.tfstate` | All repository `.tf` files inside `group-2/` |

---

## GitHub App Authentication

Authentication is managed centrally in `root.hcl` using a GitHub App. Configuration is provided dynamically via external environment variables:

- `ORG_OWNER`: Organization name (e.g. `ilegra`)
- `INFRA_APP_ID`: GitHub App ID (e.g. `5400056`)
- `INFRA_APP_INSTALATION_ID`: GitHub App Installation ID (e.g. `173489611`)
- `github-app-private-key.pem`: Private key PEM file placed in the repository root

Before running operations locally:
```bash
export ORG_OWNER="ilegra"
export INFRA_APP_ID="5400056"
export INFRA_APP_INSTALATION_ID="<your-installation-id>"
```
*(Find your installation ID in the URL: `https://github.com/organizations/<org>/settings/installations/<INSTALLATION_ID>`)*

---

## Ruleset Library (`modules/ruleset/`)

The `modules/ruleset` module serves both organization and repository scopes with pre-defined granular rulesets:

1. **`ruleset-block-force-push.tf`**: Blocks force pushes (`non_fast_forward = true`) on specified branches (defaults to `["~DEFAULT_BRANCH"]`).
2. **`ruleset-prevent-branch-deletion.tf`**: Prevents deleting branches (`deletion = true`) on specified branches (defaults to `["~DEFAULT_BRANCH"]`).
3. **`ruleset-require-pull-request.tf`**: Enforces pull requests before merging, approvals, review dismissal on push, code owner reviews, and thread resolution.
4. **`ruleset-require-status-checks.tf`**: Enforces required CI/CD status checks before merge.
5. **`ruleset-protect-tags.tf`**: Protects tags (e.g. `refs/tags/v*`) from deletion, force push, and modification.

### Calling from a Repository (`org/repositories/group-1/repo-sample-service.tf`)
```hcl
module "sample_service" {
  source = "../../../modules/repository"

  name                   = "sample-service"
  delete_branch_on_merge = true # Automatically delete feature branches after PR merge
  # ...
}

module "sample_service_rulesets" {
  source = "../../../modules/ruleset"

  repository      = module.sample_service.name
  bypass_team_ids = [lookup(var.teams, "platform-engineering", { id = "1001" }).id]

  # 1. Protect against force pushes (customize branches)
  block_force_push = {
    branches = ["~DEFAULT_BRANCH", "refs/heads/release/*"]
  }

  # 2. Prevent branch deletion (defaults to ~DEFAULT_BRANCH)
  prevent_branch_deletion = {}
}
```

### Calling at the Organization Level (`org/rulesets/terragrunt.hcl`)
When `repository = null`, rulesets are created as `github_organization_ruleset`:
```hcl
inputs = {
  repository           = null
  include_repositories = ["~ALL"]
  bypass_team_ids      = [dependency.teams.outputs.teams["platform-engineering"].id]

  block_force_push = {
    name     = "org-block-force-push"
    branches = ["~DEFAULT_BRANCH"]
  }
}
```

---

## How to Add a New Repository

To add a new repository to `group-1`, create a new `.tf` file inside `org/repositories/group-1/` (e.g. `repo-my-service.tf`):

```hcl
module "my_service" {
  source = "../../../modules/repository"

  name                   = "my-service"
  description            = "New microservice description"
  delete_branch_on_merge = true

  team_permissions = {
    (var.teams["backend-developers"].slug) = "push"
  }
}

module "my_service_rulesets" {
  source = "../../../modules/ruleset"

  repository = module.my_service.name

  block_force_push        = {}
  prevent_branch_deletion = {}
}
```

---

## Terragrunt Commands

Validate all units across the entire organization:
```bash
terragrunt run --all init
terragrunt run --all validate
```

Plan all changes across dependency order (`settings` -> `teams` -> `rulesets` -> `repositories`):
```bash
terragrunt run --all plan
```

Target a single repository group:
```bash
cd org/repositories/group-1
terragrunt plan
```

---

## CI/CD Workflow (`.github/workflows/infrastructure-pipeline.yml`)

The repository includes a GitHub Actions workflow with manual execution (`workflow_dispatch`) to safely run `apply` or `plan` either across all modules or targeted to a specific unit.

### Required GitHub Secrets & Variables

Configure these in **Settings -> Secrets and variables -> Actions**:

#### Repository Variables (Variables tab)
| Name | Description | Example |
| :--- | :--- | :--- |
| `ORG_OWNER` | Target GitHub organization name | `ilegra` |
| `INFRA_APP_ID` | GitHub App ID | `5400056` |
| `INFRA_APP_INSTALATION_ID` | GitHub App installation ID | `173489611` |

#### Repository Secrets (Secrets tab)
| Name | Description |
| :--- | :--- |
| `INFRA_APP_PRIVATE__KEY` | GitHub App private key PEM file content |

### Running from GitHub Web UI
1. Navigate to **Actions** -> **Github infrastructure pipeline**.
2. Click **Run workflow**.
3. Configure the inputs:
   - **Module**: Select `all`, `org/settings`, `org/teams`, `org/rulesets`, `org/repositories`, a specific group (`org/repositories/group-1`, `group-2`), or `custom`.
   - **Custom module**: If `custom` was selected, specify the path (e.g. `org/repositories/group-3`).
   - **Action**: `apply` (default) or `plan`.

### Running via GitHub CLI (`gh`)
Apply all modules:
```bash
gh workflow run infrastructure-pipeline.yml -f module=all -f action=apply
```

Apply only a specific module (e.g., `org/teams`):
```bash
gh workflow run infrastructure-pipeline.yml -f module=org/teams -f action=apply
```

Plan changes for a specific module:
```bash
gh workflow run infrastructure-pipeline.yml -f module=org/repositories/group-1 -f action=plan
```

