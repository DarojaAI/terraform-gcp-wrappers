resource "google_secret_manager_secret" "this" {
  project   = var.project_id
  secret_id = var.secret_id

  labels = merge(var.common_labels, {
    application = var.app_name
    environment = var.environment
    managed_by  = "terraform"
    module      = "secret-manager-secret"
  })

  replication {
    auto {}
  }
}
