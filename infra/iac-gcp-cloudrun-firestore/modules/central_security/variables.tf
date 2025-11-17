variable "sa_account_id" {
  description = "Account ID for the central SA"
  type        = string
  default     = "central-security-sa"
}

variable "secret_name" {
  description = "Name of the Flixbus api secret key in Secret Manager"
  type        = string
  default     = "flixbus-api-key"
}

variable "project_id" {
  description = "Name of the Project ID"
  type        = string
  default     = "project-1234"
}

variable "secret_env_vars" {
  type = map(string)
}

variable "secret_env_vars_keys" {
  type    = list(string)
  default = []
}