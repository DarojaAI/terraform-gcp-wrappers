# service-account

Terraform wrapper module for creating a Google service account with DarojaAI default labeling.

## What it creates

- A single `google_service_account`

## Usage

```hcl
module "sa" {
  source = "git::https://github.com/DarojaAI/terraform-gcp-wrappers.git//modules/service-account?ref=<tag>"

  app_name     = "myapp"
  environment  = "prod"
  project_id   = var.project_id
  account_id   = "myapp-prod"
  display_name = "myapp prod service account"
}
```

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `app_name` | `string` | — | Application name used for labeling |
| `environment` | `string` | — | Deployment environment (e.g., prod, staging, dev) |
| `project_id` | `string` | — | GCP project ID |
| `region` | `string` | `"us-central1"` | GCP region for resources |
| `account_id` | `string` | — | The account ID for the Google Service Account |
| `display_name` | `string` | — | The display name for the Google Service Account |
| `description` | `string` | `""` | Optional description of the Google Service Account |

## Outputs

| Name | Description |
|------|-------------|
| `email` | The email address of the service account |
| `id` | The unique ID of the service account |
| `name` | The fully-qualified name of the service account |
