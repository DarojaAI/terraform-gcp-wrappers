variable "app_name" {
  type        = string
  description = "Application name used for labeling and resource naming"
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
  description = "GCP region for the Artifact Registry repository"
}

variable "repository_id" {
  type        = string
  description = "Unique identifier for the Artifact Registry repository"
}

variable "format" {
  type        = string
  default     = "DOCKER"
  description = "Artifact repository format (e.g., DOCKER, MAVEN, NPM, PYTHON)"
}

variable "common_labels" {
  type        = map(string)
  default     = {}
  description = "Common labels to merge into all resources"
}
