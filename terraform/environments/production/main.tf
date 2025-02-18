provider "google" {
  project = var.project_id
  region  = var.region
}

module "cloud_run" {
  source = "../../modules/cloud-run"

  project_id   = var.project_id
  region       = var.region
  service_name = "nodejs-server-prod"
  image_url    = var.image_url
  environment  = "production"
} 