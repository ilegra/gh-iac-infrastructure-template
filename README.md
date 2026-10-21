# GitHub Infrastructure as Code Skeleton

Production-ready GitHub Infrastructure-as-Code (IaC) skeleton repository and template for GitHub organizations using **Terraform (>= 1.16.0)** with the [`integrations/github`](https://registry.terraform.io/providers/integrations/github/latest/docs) provider (~> 6.0) and **Terragrunt (>= 1.1.0)** for modular state isolation and orchestration.

---

## Using this Repository as a Template

To use this skeleton to manage your organization's GitHub infrastructure:

1. Click **Use this template** $\rightarrow$ **Create a new repository** in the GitHub UI.
2. Select your target GitHub organization and choose a repository name (e.g., `gh-infrastructure`).
3. Follow the [GitHub App Setup Guide](#github-app-setup-guide) below to create and configure a dedicated GitHub App for authentication.
4. Configure your repository secrets and variables.
5. Customize `org/settings/terragrunt.hcl`, `org/teams/terragrunt.hcl`, and repository definitions for your organization.
6. Run the CI/CD pipeline via GitHub Actions.

---

## GitHub App Setup Guide

Terraform authenticates with GitHub using a dedicated **GitHub App**. Each organization using this template must create, install, and configure its own GitHub App to grant Terragrunt programmatic administrative access.

```
┌─────────────────────────────────┐
│     Target GitHub Org           │
│  ┌───────────────────────────┐  │
│  │       GitHub App          │  │
│  │ (Org & Repo Permissions)  │  │
│  └─────────────┬─────────────┘  │
│                │ Installed      │
│                ▼                │
│  ┌───────────────────────────┐  │
│  │  Template Infrastructure  │◄─┼─── GitHub Actions Pipeline
│  │        Repository         │  │     (Runs Terragrunt Plan/Apply)
│  └───────────────────────────┘  │
└─────────────────────────────────┘
```

### Step 1: Create the GitHub App

1. Sign in to GitHub and navigate to your organization:
   `https://github.com/organizations/<YOUR_ORG>/settings/apps/new`
   *(Or go to **Organization Settings** $\rightarrow$ **Developer settings** $\rightarrow$ **GitHub Apps** $\rightarrow$ **New GitHub App**)*
2. Fill in the **Basic Information**:
   - **GitHub App name**: `gh-infra-manager-<YOUR_ORG>` (must be globally unique)
   - **Homepage URL**: `https://github.com/<YOUR_ORG>`
3. **Webhook**:
   - Uncheck **Active** (no webhook URL required for IaC management).

### Step 2: Configure App Permissions

Under **Permissions**, configure the following permissions:

#### Organization Permissions
| Permission | Access | Purpose |
| :--- | :--- | :--- |
| **Administration** | Read and write | Manage org profile, repository creation permissions, and security defaults |
| **Members** | Read and write | Manage teams, team memberships, and org invitations |
| **Custom organization roles** | Read and write *(Optional)* | Manage custom org roles if applicable |
| **Organization rulesets** | Read and write | Manage org-wide rulesets (force push, branch deletion, PR checks) |

#### Repository Permissions
| Permission | Access | Purpose |
| :--- | :--- | :--- |
| **Administration** | Read and write | Create and update repositories, manage topics, delete branches on merge |
| **Rulesets** | Read and write | Configure repository-level rulesets and branch protections |
| **Metadata** | Read-only *(Auto-selected)* | Inspect repository metadata and search |
| **Pull requests** | Read and write *(Optional)* | Required if managing automated PR workflows |

#### Where can this GitHub App be installed?
- Select **Only on this account** (limits the app exclusively to your organization).

Click **Create GitHub App**.

### Step 3: Generate a Private Key & Note IDs

After creating the app:
1. On the app's **General** page:
   - Note the **App ID** (e.g. `1234567`).
2. Scroll down to **Private keys** and click **Generate a private key**.
3. A `.pem` file will automatically download (e.g. `gh-infra-manager.2026-10-20.private-key.pem`). Keep this file secure!

### Step 4: Install the App in Your Organization

1. In the left navigation of your GitHub App settings, click **Install App**.
2. Click **Install** next to your organization name.
3. Under **Repository access**, select **All repositories** (or select specific repositories).
4. Click **Install**.
5. After installation, note the **Installation ID** from your browser URL:
   ```
   https://github.com/organizations/<YOUR_ORG>/settings/installations/<INSTALLATION_ID>
                                                                     ▲
                                                          Copy this number
   ```

### Step 5: Configure Repository Secrets & Variables

In the repository created from this template, navigate to:
**Settings** $\rightarrow$ **Secrets and variables** $\rightarrow$ **Actions**

#### Repository Variables (Variables Tab)
Click **New repository variable**:

| Name | Description | Example |
| :--- | :--- | :--- |
| `ORG_OWNER` | Target GitHub organization slug | `acme-corp` |
| `INFRA_APP_ID` | Numeric GitHub App ID from Step 3 | `1234567` |
| `INFRA_APP_INSTALLATION_ID` | Numeric Installation ID from Step 4 | `98765432` |

> [!NOTE]
> `INFRA_APP_INSTALATION_ID` (single 'l') is also recognized for backwards compatibility.

#### Repository Secrets (Secrets Tab)
Click **New repository secret**:

| Name | Description | Example |
| :--- | :--- | :--- |
| `INFRA_APP_PRIVATE_KEY` | Full content of the `.pem` file downloaded in Step 3 | `-----BEGIN RSA PRIVATE KEY-----...` |

*(Note: `INFRA_APP_PRIVATE__KEY` with double underscore is also supported).*

---

## Local Development Setup

To run Terragrunt locally from your machine:

1. Copy your downloaded GitHub App private key to the repository root:
   ```bash
   cp ~/Downloads/*.private-key.pem github-app-private-key.pem
   chmod 600 github-app-private-key.pem
   ```
   *(The file `github-app-private-key.pem` is already included in `.gitignore`)*

2. Export the required environment variables:
   ```bash
   export ORG_OWNER="<YOUR_ORG>"
   export INFRA_APP_ID="<YOUR_APP_ID>"
   export INFRA_APP_INSTALLATION_ID="<YOUR_INSTALLATION_ID>"
   ```

3. Test authentication and plan:
   ```bash
   terragrunt run --all plan
   ```

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

## Terragrunt CLI Commands

Terragrunt allows you to run commands across the entire organization hierarchy at once, or target specific individual modules/units.

### Prerequisite Environment Variables

Before running commands, ensure your GitHub App credentials and organization variables are exported:

```bash
export GITHUB_OWNER="<YOUR_ORG>"
export GITHUB_APP_ID="<YOUR_APP_ID>"
export GITHUB_APP_INSTALLATION_ID="<YOUR_APP_INSTALLATION_ID>"
```

---

### Option 1: Apply All Modules (Complete Stack)

To plan or apply all units across the entire organization hierarchy, run from the repository root:

```bash
# 1. Initialize and validate all units
terragrunt run --all init --working-dir org
terragrunt run --all validate --working-dir org

# 2. Review plan for all units (executes in dependency order)
terragrunt run --all plan --working-dir org

# 3. Apply all units interactively
terragrunt run --all apply --working-dir org

# 4. Non-interactive apply (auto-approved, for automation/scripts)
terragrunt run --all apply --non-interactive --working-dir org -- -auto-approve
```

> [!NOTE]
> Terragrunt automatically detects dependency blocks and coordinates execution in the correct hierarchical order:
> `org/settings` (in parallel) & `org/teams` $\rightarrow$ `org/rulesets` $\rightarrow$ `org/repositories/group-1` & `group-2`.

---

### Option 2: Apply Module per Module (Targeted Execution)

You can apply modules individually by targeting their specific directory using either `--working-dir` from the repository root or by navigating (`cd`) directly into the module directory.

Follow this recommended dependency sequence when deploying fresh infrastructure module-by-module:

#### 1. Organization Settings (`org/settings`)
Applies organization-level profile, defaults, and security configurations:
```bash
# From repository root
terragrunt run apply --working-dir org/settings

# Or by navigating to directory
cd org/settings
terragrunt apply
```

#### 2. Teams & Memberships (`org/teams`)
Creates teams (e.g. `platform-engineering`, `security`, developer teams) and assigns memberships:
```bash
# From repository root
terragrunt run apply --working-dir org/teams

# Or by navigating to directory
cd org/teams
terragrunt apply
```

#### 3. Organization Rulesets (`org/rulesets`)
Deploys org-wide protection rules (requires teams from step 2 for bypass permissions):
```bash
# From repository root
terragrunt run apply --working-dir org/rulesets

# Or by navigating to directory
cd org/rulesets
terragrunt apply
```

#### 4. Repository Groups (`org/repositories/*`)
Applies repositories, environment protections, repository rulesets, and team access:

- **Target a single repository group (e.g., `group-1`)**:
  ```bash
  # From repository root
  terragrunt run apply --working-dir org/repositories/group-1

  # Or by navigating to directory
  cd org/repositories/group-1
  terragrunt apply
  ```

- **Target a second repository group (e.g., `group-2`)**:
  ```bash
  # From repository root
  terragrunt run apply --working-dir org/repositories/group-2

  # Or by navigating to directory
  cd org/repositories/group-2
  terragrunt apply
  ```

- **Apply all repository groups at once without touching settings or teams**:
  ```bash
  terragrunt run --all apply --working-dir org/repositories
  ```

---

### Useful Terragrunt Flags & Shortcuts

| Command / Flag | Purpose |
| :--- | :--- |
| `terragrunt run --all <cmd>` | Runs `<cmd>` across all child Terragrunt units recursively. |
| `--working-dir <path>` | Targets execution in `<path>` without needing to `cd`. |
| `--non-interactive` | Disables interactive prompts for CI/CD scripting. |
| `-- -auto-approve` | Passes the `-auto-approve` flag directly to Terraform. |
| `terragrunt plan` | Runs plan only in the current working directory. |
| `terragrunt apply` | Runs apply only in the current working directory. |
| `terragrunt destroy` | Destroys resources only in the current working directory. |
| `terragrunt run --all destroy` | Destroys resources in reverse dependency order. |

---

## CI/CD Workflow (`.github/workflows/infrastructure-pipeline.yml`)

The repository includes a GitHub Actions workflow with manual execution (`workflow_dispatch`) to safely run `apply` or `plan` either across all modules or targeted to a specific unit.

### Required GitHub Secrets & Variables

Configure these in **Settings -> Secrets and variables -> Actions**:

#### Repository Variables (Variables tab)
| Name | Description | Example |
| :--- | :--- | :--- |
| `ORG_OWNER` | Target GitHub organization name | `acme-corp` |
| `INFRA_APP_ID` | Numeric GitHub App ID | `1234567` |
| `INFRA_APP_INSTALLATION_ID` | GitHub App installation ID | `98765432` |

> [!NOTE]
> `INFRA_APP_INSTALATION_ID` (single 'l') is also recognized for backwards compatibility.

#### Repository Secrets (Secrets tab)
| Name | Description |
| :--- | :--- |
| `INFRA_APP_PRIVATE_KEY` | Full content of the GitHub App private key `.pem` file (`INFRA_APP_PRIVATE__KEY` also supported) |

### Running from GitHub Web UI
1. Navigate to **Actions** -> **Github infrastructure pipeline**.
2. Click **Run workflow**.
3. Configure the inputs:
   - **Module**: Select `all`, `org/settings`, `org/teams`, `org/rulesets`, `org/repositories`, or a specific group (`org/repositories/group-1`, `group-2`).
   - **Action**: `apply` (default), `plan`, or `destroy`.

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

