output "id" {
  description = "The ID of the Artifact Registry repository"
  value       = google_artifact_registry_repository.this.id
}

output "name" {
  description = "The name of the Artifact Registry repository"
  value       = google_artifact_registry_repository.this.name
}
