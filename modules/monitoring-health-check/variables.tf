variable "app_name" {
  type        = string
  description = "Application name"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., prod, staging, dev)"
}

variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "display_name_prefix" {
  type        = string
  description = "Prefix for display names of monitoring resources"
}

variable "host" {
  type        = string
  description = "Hostname to monitor"
}

variable "path" {
  type        = string
  default     = "/health"
  description = "Path for the health check"
}

variable "port" {
  type        = number
  default     = 443
  description = "Port for the health check"
}

variable "period" {
  type        = string
  default     = "300s"
  description = "Frequency of the uptime check"
}

variable "timeout" {
  type        = string
  default     = "10s"
  description = "Timeout for each health check request"
}

variable "threshold" {
  type        = number
  default     = 0.5
  description = "Alert threshold (fraction of failed checks)"
}

variable "duration" {
  type        = string
  default     = "600s"
  description = "Duration over which the threshold is evaluated"
}

variable "notification_channels" {
  type        = list(string)
  description = "List of notification channel IDs for the alert policy"
}

variable "alert_severity" {
  type        = string
  default     = "CRITICAL"
  description = "Severity of the alert policy"
}

variable "common_labels" {
  type        = map(string)
  default     = {}
  description = "Common labels to merge into resource labels"
}
