# monitoring-health-check

Terraform wrapper module for creating a Google Cloud Monitoring uptime check and alert policy for a public endpoint.

## What it creates

- A `google_monitoring_uptime_check_config` against `host` + `path` (default `/health`)
- A `google_monitoring_alert_policy` that fires when the failed-check fraction crosses `threshold`

## Usage

```hcl
module "health_check" {
  source = "git::https://github.com/DarojaAI/terraform-gcp-wrappers.git//modules/monitoring-health-check?ref=<tag>"

  app_name             = "myapp"
  environment          = "prod"
  project_id           = var.project_id
  display_name_prefix  = "myapp"
  host                 = "myapp.example.com"
  notification_channels = [var.alert_channel_id]
}
```

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `app_name` | `string` | — | Application name |
| `environment` | `string` | — | Deployment environment (e.g., prod, staging, dev) |
| `project_id` | `string` | — | GCP project ID |
| `display_name_prefix` | `string` | — | Prefix for display names of monitoring resources |
| `host` | `string` | — | Hostname to monitor |
| `path` | `string` | `"/health"` | Path for the health check |
| `port` | `number` | `443` | Port for the health check |
| `period` | `string` | `"300s"` | Frequency of the uptime check |
| `timeout` | `string` | `"10s"` | Timeout for each health check request |
| `threshold` | `number` | `0.5` | Alert threshold (fraction of failed checks) |
| `duration` | `string` | `"600s"` | Duration over which the threshold is evaluated |
| `notification_channels` | `list(string)` | — | List of notification channel IDs for the alert policy |
| `alert_severity` | `string` | `"CRITICAL"` | Severity of the alert policy |
| `common_labels` | `map(string)` | `{}` | Common labels to merge into resource labels |

## Outputs

| Name | Description |
|------|-------------|
| `uptime_check_id` | ID of the uptime check config |
| `alert_policy_id` | ID of the alert policy |
