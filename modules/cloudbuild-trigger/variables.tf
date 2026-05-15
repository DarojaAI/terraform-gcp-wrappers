variable "app_name" {
  type        = string
  description = "Application name for labeling"
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
  description = "GCP region"
  default     = "us-central1"
}

variable "name" {
  type        = string
  description = "Name of the Cloud Build trigger"
}

variable "description" {
  type        = string
  description = "Description of the Cloud Build trigger"
  default     = ""
}

variable "github_owner" {
  type        = string
  description = "GitHub repository owner"
}

variable "github_repo" {
  type        = string
  description = "GitHub repository name"
}

variable "branch" {
  type        = string
  description = "Git branch pattern to trigger builds (e.g., ^main$)"
}

variable "filename" {
  type        = string
  description = "Path to the Cloud Build configuration file"
  default     = "cloudbuild.yaml"
}

variable "substitutions" {
  type        = map(string)
  description = "Map of substitution variables for the build"
  default     = {}
}

variable "disabled" {
  type        = bool
  description = "Whether the trigger is disabled"
  default     = false
}
