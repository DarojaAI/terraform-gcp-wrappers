output "internal_ip" {
  description = "Internal IP address of the PostgreSQL VM"
  value       = module.postgres.internal_ip
}

output "connection_string_internal" {
  description = "Internal PostgreSQL connection string"
  value       = module.postgres.connection_string_internal
  sensitive   = true
}

output "instance_name" {
  description = "Name of the Compute Engine instance"
  value       = module.postgres.instance_name
}

output "backup_bucket_name" {
  description = "GCS bucket used for PostgreSQL backups"
  value       = module.postgres.backup_bucket_name
}
output "secrets" {
  description = "Map of Secret Manager secret IDs for PostgreSQL credentials"
  value       = module.postgres.secrets
}

output "zone" {
  description = "Compute zone where the PostgreSQL instance is deployed"
  value       = module.postgres.zone
}
