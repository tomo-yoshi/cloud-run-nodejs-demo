output "service_url" {
  value       = module.cloud_run.service_url
  description = "The URL of the deployed preview environment"
} 