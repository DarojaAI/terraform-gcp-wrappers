output "id" {
  description = "The ID of the Secret Manager secret"
  value       = google_secret_manager_secret.this.id
}

output "name" {
  description = "The resource name of the Secret Manager secret"
  value       = google_secret_manager_secret.this.name
}

output "secret_id" {
  description = "The secret ID of the Secret Manager secret"
  value       = google_secret_manager_secret.this.secret_id
}
