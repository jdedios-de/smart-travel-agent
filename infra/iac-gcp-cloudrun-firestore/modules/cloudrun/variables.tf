variable "region" {}
variable "service_name" {}
variable "container_image" {
  default = "europe-west3-docker.pkg.dev/smart-travel-agentic/smarttravelagent/smart-travel-agent:v1"
}
variable "secret_env_vars_keys" {
  type    = list(string)
  default = []
}
variable "service_account_email" {
  description = "GCP service account the Cloud Run service will run as"
  type        = string
}