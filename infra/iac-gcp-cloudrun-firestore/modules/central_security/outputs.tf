output "service_account_email" {
  value = google_service_account.central_sa.email
}

output "secret_name" {
  value = google_secret_manager_secret.api_key.secret_id
}