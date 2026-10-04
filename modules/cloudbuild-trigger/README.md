# cloudbuild-trigger

Terraform wrapper module for creating a GitHub-sourced Cloud Build trigger.

## What it creates

- A single `google_cloudbuild_trigger` wired to a GitHub repository and branch pattern

## Usage

```hcl
module "build_trigger" {
  source = "git::https://github.com/DarojaAI/terraform-gcp-wrappers.git//modules/cloudbuild-trigger?ref=<tag>"

  app_name     = "myapp"
  environment  = "prod"
  project_id   = var.project_id
  name         = "myapp-prod-build"
  github_owner = "DarojaAI"
  github_repo  = "myapp"
  branch       = "^main$"
  filename     = "cloudbuild.yaml"
}
```

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `app_name` | `string` | — | Application name for labeling |
| `environment` | `string` | — | Deployment environment (e.g., prod, staging, dev) |
| `project_id` | `string` | — | GCP project ID |
| `region` | `string` | `"us-central1"` | GCP region |
| `name` | `string` | — | Name of the Cloud Build trigger |
| `description` | `string` | `""` | Description of the Cloud Build trigger |
| `github_owner` | `string` | — | GitHub repository owner |
| `github_repo` | `string` | — | GitHub repository name |
| `branch` | `string` | — | Git branch pattern to trigger builds (e.g., `^main$`) |
| `filename` | `string` | `"cloudbuild.yaml"` | Path to the Cloud Build configuration file |
| `substitutions` | `map(string)` | `{}` | Map of substitution variables for the build |
| `disabled` | `bool` | `false` | Whether the trigger is disabled |

## Outputs

| Name | Description |
|------|-------------|
| `id` | The unique identifier for the Cloud Build trigger |
| `name` | The name of the Cloud Build trigger |
