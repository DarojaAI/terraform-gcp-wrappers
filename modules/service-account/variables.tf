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

variable "account_id" {
  type        = string
  description = "The account ID for the Google Service Account"
}

variable "display_name" {
  type        = string
  description = "The display name for the Google Service Account"
}

variable "description" {
  type        = string
  default     = ""
  description = "Optional description of the Google Service Account"
}
