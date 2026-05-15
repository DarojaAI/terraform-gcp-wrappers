resource "google_artifact_registry_repository" "this" {
  project       = var.project_id
  location      = var.region
  repository_id = var.repository_id
  format        = var.format

  labels = merge(var.common_labels, {
    application = var.app_name
    environment = var.environment
    managed_by  = "terraform"
    module      = "artifact-registry"
  })
}
