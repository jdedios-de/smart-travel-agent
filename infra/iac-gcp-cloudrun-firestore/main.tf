# Enable required APIs
resource "google_project_service" "apis" {
  for_each = toset([
    "run.googleapis.com",
    "secretmanager.googleapis.com",
    "firestore.googleapis.com",
    "cloudbuild.googleapis.com",
    "billingbudgets.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com"
  ])
  project = var.project_id
  service = each.value

  disable_on_destroy = false
}

# Central Security module
module "central_security" {
  source               = "./modules/central_security"
  project_id           = var.project_id
  secret_env_vars      = var.secret_env_vars
  secret_env_vars_keys = keys(var.secret_env_vars)
}

# Observability module
module "observability" {
  source = "./modules/observability"

  project_id = var.project_id
}

# Cloud Run module
module "cloudrun" {
  source                = "./modules/cloudrun"
  region                = var.region
  service_name          = var.service_name
  container_image       = var.container_image
  secret_env_vars_keys  = keys(var.secret_env_vars)
  service_account_email = module.central_security.service_account_email
}

module "billing_budget" {
  source                = "./modules/billing_budget"
  billing_account_id    = var.billing_account_id

  billing_email_address = "jeromededios.de.2023@gmail.com"
  prefix                = "Smart Travel Agent"
}