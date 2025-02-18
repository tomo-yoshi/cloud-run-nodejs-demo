variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

variable "image_url" {
  description = "The URL of the Docker image to deploy"
  type        = string
}

variable "pr_number" {
  description = "The PR number for the preview environment"
  type        = string
} 