terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }

  backend "gcs" {
    bucket = "smart-travel-agentic"
    prefix = "envs/dev"
  }
}

provider "google" {
  project = "smart-travel-agentic"
  region  = "europe-west3"

  billing_project = "smart-travel-agentic"
  user_project_override = true
}
