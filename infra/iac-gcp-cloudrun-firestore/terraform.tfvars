project_id      = "smart-travel-agentic"
region          = "europe-west3"
service_name    = "hello-api"
container_image = "europe-west3-docker.pkg.dev/smart-travel-agentic/smarttravelagent/smart-travel-agent:v1"

env_vars = {
  NODE_ENV = "development"
}

secret_env_vars = {
  DB_PASSWORD   = "db-password"
  API_KEY       = "api-key"
}