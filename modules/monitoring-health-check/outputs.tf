output "uptime_check_id" {
  description = "ID of the uptime check config"
  value       = google_monitoring_uptime_check_config.this.uptime_check_id
}

output "alert_policy_id" {
  description = "ID of the alert policy"
  value       = google_monitoring_alert_policy.this.id
}
