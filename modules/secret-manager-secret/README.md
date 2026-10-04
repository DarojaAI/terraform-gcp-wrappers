# secret-manager-secret

Terraform wrapper module for creating a Google Secret Manager secret with DarojaAI default labeling.

## What it creates

- A single `google_secret_manager_secret` (secret version management is left to the caller)

## Usage

```hcl
module "secret" {
  source = "git::https://github.com/DarojaAI/terraform-gcp-wrappers.git//modules/secret-manager-secret?ref=<tag>"

  app_name     = "myapp"
  environment  = "prod"
  project_id   = var.project_id
  secret_id    = "myapp-api-key"
}
```

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `app_name` | `string` | — | Application name used for labeling |
| `environment` | `string` | — | Deployment environment (e.g., prod, staging, dev) |
| `project_id` | `string` | — | GCP project ID |
| `region` | `string` | `"us-central1"` | GCP region for resources |
| `secret_id` | `string` | — | The secret ID for the Google Secret Manager secret |
| `common_labels` | `map(string)` | `{}` | Optional map of common labels to merge with hardcoded labels |

## Outputs

| Name | Description |
|------|-------------|
| `id` | The ID of the Secret Manager secret |
| `name` | The resource name of the Secret Manager secret |
| `secret_id` | The secret ID of the Secret Manager secret |
