variable "project_id" {}
variable "region" {}
variable "service_name" {}
variable "container_image" {
  default = "europe-west3-docker.pkg.dev/smart-travel-agentic/smarttravelagent/smart-travel-agent:v1"
}
variable "env_vars" { type = map(string) }
variable "secret_env_vars" { type = map(string) }
variable "secret_env_vars_keys" {
  type    = list(string)
  default = []
}