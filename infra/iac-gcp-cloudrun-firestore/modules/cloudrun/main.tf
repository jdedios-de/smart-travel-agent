resource "google_service_account" "run_sa" {
  account_id   = "${var.service_name}-sa"
  display_name = "${var.service_name} Cloud Run SA"
}

resource "google_project_iam_member" "run_invoker" {
  project = var.project_id
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.run_sa.email}"

   depends_on = [google_service_account.run_sa]
}

resource "google_secret_manager_secret_iam_member" "secret_accessor" {
    for_each = toset(var.secret_env_vars_keys)
    project = var.project_id
    secret_id = each.value
    role = "roles/secretmanager.secretAccessor"
    member = "serviceAccount:${google_service_account.run_sa.email}"

    depends_on = [google_service_account.run_sa]
}

# Cloud Run service
resource "google_cloud_run_v2_service" "default" {
      name     = var.service_name
      location = var.region
      ingress  = "INGRESS_TRAFFIC_ALL"
      deletion_protection = false

      template {
        service_account = google_service_account.run_sa.email
        containers {
          image = var.container_image

            dynamic "env" {
              for_each = toset(var.secret_env_vars_keys)
              content {
                name = env.key
                value_source {
                  secret_key_ref {
                    secret   = env.key
                    version  = "latest"
                  }
                }
              }
            }
        }
      }
  traffic {
    percent = 100
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
  }
}

resource "google_cloud_run_v2_service_iam_member" "public" {
  location = google_cloud_run_v2_service.default.location
  name     = google_cloud_run_v2_service.default.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}