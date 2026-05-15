variable "app_name" {
  type        = string
  description = "Application name used for labeling"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., prod, staging, dev)"
}

variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "GCP region for resources"
}

variable "secret_id" {
  type        = string
  description = "The secret ID for the Google Secret Manager secret"
}

variable "common_labels" {
  type        = map(string)
  default     = {}
  description = "Optional map of common labels to merge with hardcoded labels"
}
