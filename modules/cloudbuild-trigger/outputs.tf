output "id" {
  description = "The unique identifier for the Cloud Build trigger"
  value       = google_cloudbuild_trigger.this.id
}

output "name" {
  description = "The name of the Cloud Build trigger"
  value       = google_cloudbuild_trigger.this.name
}
