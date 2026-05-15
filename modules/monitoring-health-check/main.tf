locals {
  labels = merge(var.common_labels, {
    application = var.app_name
    environment = var.environment
  })
}

resource "google_monitoring_uptime_check_config" "this" {
  display_name = "${var.display_name_prefix}-uptime"
  timeout      = var.timeout
  period       = var.period

  http_check {
    path = var.path
    port = var.port
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.project_id
      host       = var.host
    }
  }

  user_labels = local.labels
}

resource "google_monitoring_alert_policy" "this" {
  display_name = "${var.display_name_prefix}-alert"
  combiner     = "OR"

  conditions {
    display_name = "Uptime check failure"

    condition_threshold {
      filter = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND resource.type=\"uptime_url\" AND metric.labels.check_id=\"${google_monitoring_uptime_check_config.this.uptime_check_id}\""
      aggregations {
        alignment_period     = var.period
        per_series_aligner   = "ALIGN_FRACTION_TRUE"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["resource.label.project_id", "resource.label.host"]
      }
      duration        = var.duration
      comparison      = "COMPARISON_LT"
      threshold_value = var.threshold
    }
  }

  notification_channels = var.notification_channels
  severity              = var.alert_severity
  user_labels           = local.labels
}
