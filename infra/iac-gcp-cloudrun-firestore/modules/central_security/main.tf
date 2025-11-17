
# Service Account
resource "google_service_account" "central_sa" {
  account_id   = var.sa_account_id
  display_name = "Central Security SA – API keys & secrets"
}

resource "google_project_iam_member" "run_invoker" {
  project = var.project_id
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.central_sa.email}"

  depends_on = [google_service_account.central_sa]
}

# Secret that holds the real FlixBus API key
resource "google_secret_manager_secret" "api_key" {
  secret_id = var.secret_name

  replication {
    auto {}
  }
}

# Give the central SA permission to read the api key
resource "google_secret_manager_secret_iam_member" "accessor" {
  secret_id = google_secret_manager_secret.api_key.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.central_sa.email}"
}

resource "google_secret_manager_secret" "secret" {
  for_each = var.secret_env_vars
  secret_id = each.key
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "secret_value" {
  for_each = var.secret_env_vars

  secret      = google_secret_manager_secret.secret[each.key].id
  secret_data = each.value
}

# Give the central SA permission to read the secret
resource "google_secret_manager_secret_iam_member" "secret_accessor" {
  for_each = toset(var.secret_env_vars_keys)
  secret_id = each.value
  role = "roles/secretmanager.secretAccessor"
  member = "serviceAccount:${google_service_account.central_sa.email}"

  depends_on = [google_service_account.central_sa]
}