resource "google_cloudbuild_trigger" "this" {
  project     = var.project_id
  name        = var.name
  description = var.description
  disabled    = var.disabled

  github {
    owner = var.github_owner
    name  = var.github_repo

    push {
      branch = var.branch
    }
  }

  filename = var.filename

  substitutions = var.substitutions
}
