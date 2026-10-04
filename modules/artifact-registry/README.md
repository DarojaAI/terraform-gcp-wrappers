# artifact-registry

Terraform wrapper module for creating a Google Artifact Registry repository with DarojaAI default labeling.

## What it creates

- A single `google_artifact_registry_repository` (default format `DOCKER`)

## Usage

```hcl
module "registry" {
  source = "git::https://github.com/DarojaAI/terraform-gcp-wrappers.git//modules/artifact-registry?ref=<tag>"

  app_name     = "myapp"
  environment  = "prod"
  project_id   = var.project_id
  region       = "us-central1"
  repository_id = "myapp"
}
```

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `app_name` | `string` | — | Application name used for labeling and resource naming |
| `environment` | `string` | — | Deployment environment (e.g., prod, staging, dev) |
| `project_id` | `string` | — | GCP project ID |
| `region` | `string` | — | GCP region for the Artifact Registry repository |
| `repository_id` | `string` | — | Unique identifier for the Artifact Registry repository |
| `format` | `string` | `"DOCKER"` | Artifact repository format (e.g., DOCKER, MAVEN, NPM, PYTHON) |
| `common_labels` | `map(string)` | `{}` | Common labels to merge into all resources |

## Outputs

| Name | Description |
|------|-------------|
| `id` | The ID of the Artifact Registry repository |
| `name` | The name of the Artifact Registry repository |

## Examples

- Referenced by `examples/` consumers when a per-app registry is needed.
