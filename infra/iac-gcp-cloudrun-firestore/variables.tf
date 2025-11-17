variable "project_id" {
  description = "Smart Travel Agent"
  type        = string
}

variable "region" {
  description = "GCP region for resources"
  type        = string
  default     = "europe-west3"
}

variable "service_name" {
  description = "Cloud Run service name"
  type        = string
  default     = "smart-travel-agentic"
}

variable "container_image" {
  description = "Docker image"
  type        = string
}

variable "env_vars" {
  description = "Map of environment variables (non-secret)"
  type        = map(string)
  default     = {}
}

variable "secret_env_vars" {
  description = "Map of secret env vars → Secret Manager secret IDs (without version)"
  type        = map(string)
  default     = {}
}