# Cloud Run service
resource "google_cloud_run_v2_service" "default" {
      name     = var.service_name
      location = var.region
      ingress  = "INGRESS_TRAFFIC_ALL"
      deletion_protection = false

      template {
        service_account = var.service_account_email
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