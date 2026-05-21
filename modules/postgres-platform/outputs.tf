# =============================================================================
# PostgreSQL Platform Module — Outputs
# =============================================================================
# Pass-through outputs from the inner gcp-postgres-terraform module.
# State addresses remain module.postgres.module.postgres.* for compatibility.
# =============================================================================

output "zone" {
  description = "Zone where the PostgreSQL VM is running"
  value       = module.postgres.zone
}

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

output "secret_names" {
  description = "Secret Manager secret names for credentials"
  value       = module.postgres.secret_names
}

output "external_ip" {
  description = "External IP address of the PostgreSQL VM (if assign_external_ip = true)"
  value       = module.postgres.external_ip
}

output "connection_string_external" {
  description = "External PostgreSQL connection string (if assign_external_ip = true)"
  value       = module.postgres.connection_string_external
  sensitive   = true
}
