# Enable required APIs
resource "google_project_service" "apis" {
  for_each = toset([
    "run.googleapis.com",
    "secretmanager.googleapis.com",
    "firestore.googleapis.com",
    "cloudbuild.googleapis.com"
  ])
  project = var.project_id
  service = each.value

  disable_on_destroy = false
}

# Cloud Run module
module "cloudrun" {
  source = "./modules/cloudrun"

  project_id           = var.project_id
  region               = var.region
  service_name         = var.service_name
  container_image      = var.container_image
  env_vars             = var.env_vars
  secret_env_vars      = var.secret_env_vars
  secret_env_vars_keys = keys(var.secret_env_vars)
}

# Secrets module
module "secrets" {
  source = "./secrets"
  secret_env_vars = var.secret_env_vars
}
