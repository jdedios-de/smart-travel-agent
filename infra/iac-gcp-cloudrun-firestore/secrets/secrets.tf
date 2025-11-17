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
