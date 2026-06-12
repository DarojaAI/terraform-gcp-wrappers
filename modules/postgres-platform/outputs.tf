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

# =============================================================================
# vm_changed — for CI post-apply wait gating
# =============================================================================
# Returns `true` when the postgres VM was created or replaced in the most
# recent apply (i.e. the VM is being (re)booted and a post-apply
# serial-port wait is necessary). Returns `false` when the VM existed
# before this apply and is unchanged (no reboot needed).
#
# Implementation: queries the instance from GCP. If the data source
# can't find the instance (because it doesn't exist yet, or is being
# replaced), `vm_changed` is `true`. If the instance exists, `false`.
#
# Use this in CI to gate the `gcloud compute instances
# get-serial-port-output` poll that waits for PostgreSQL to start.
# Saves up to 15 min of CI time per no-op apply.
#
# See issue #10 for the original ask, and #11 for the design history.
# This output supersedes both issues' proposed implementations by
# using a `data` source (no inner-module fork required).
# =============================================================================

output "vm_changed" {
  description = "True if the postgres VM was created or replaced in this apply (caller should wait for boot). False if the VM existed and was unchanged (no wait needed). Use to gate post-apply serial-port polling in CI."
  value       = try(data.google_compute_instance.postgres.self_link, null) == null
}
