# Cloud Run Node.js Template

This repository demonstrates a complete CI/CD setup for deploying a Node.js server to Google Cloud Run with preview, staging, and production environments.

## 🚀 Quick Start

### Prerequisites
- Node.js (v18 or later)
- pnpm (or npm/yarn)
- Docker
- Google Cloud CLI

### Local Development

1. Install dependencies:
```bash
pnpm install
```

2. Start development server:
```bash
pnpm dev
```

3. Build for production:
```bash
pnpm build
```

4. Start production server:
```bash
pnpm start
```

## 🔐 Setting Up GitHub Secrets

The following secrets need to be configured in your GitHub repository settings:

- GCP_PROJECT_ID # Your Google Cloud Project ID
- GCP_REGION # e.g., asia-northeast1
- GCP_SERVICE_ACCOUNT_KEY # JSON key for preview/staging deployments
- GCP_SERVICE_ACCOUNT # Service account email for production
- GCP_WORKLOAD_IDENTITY_PROVIDER # Workload Identity Provider for production
- GCP_CLOUD_RUN_STAGING_INSTANCE_NAME # Name for staging instance
- GCP_CLOUD_RUN_PRODUCTION_INSTANCE_NAME # Name for production instance   

## 🛠️ Google Cloud Setup Guide

### 1. Create a Google Cloud Project

```bash
# Create new project
gcloud projects create YOUR_PROJECT_ID
# Set as current project
gcloud config set project YOUR_PROJECT_ID
``` 
### 2. Enable Required APIs

```bash
# Enable necessary services
gcloud services enable \
cloudbuild.googleapis.com \
run.googleapis.com \
containerregistry.googleapis.com \
artifactregistry.googleapis.com
``` 
### 3. Create Service Account for Preview/Staging

```bash
# Create service account
gcloud iam service-accounts create github-actions-deploy \
--display-name="GitHub Actions Deploy"
# Generate and download key
gcloud iam service-accounts keys create key.json \
--iam-account=github-actions-deploy@YOUR_PROJECT_ID.iam.gserviceaccount.com
``` 
### 4. Grant Required Permissions

```bash
# Grant Cloud Run Admin role
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
--member="serviceAccount:github-actions-deploy@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
--role="roles/run.admin"
# Grant Storage Admin role (for container registry)
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
--member="serviceAccount:github-actions-deploy@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
--role="roles/storage.admin"
# Grant Service Account User role
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
--member="serviceAccount:github-actions-deploy@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
--role="roles/iam.serviceAccountUser"
``` 
### 5. Setup Workload Identity Federation (for Production)

```bash
# Create Workload Identity Pool
gcloud iam workload-identity-pools create "github-actions-pool" \
--location="global" \
--display-name="GitHub Actions Pool"
# Create Workload Identity Provider
gcloud iam workload-identity-pools providers create-oidc "github-provider" \
--location="global" \
--workload-identity-pool="github-actions-pool" \
--display-name="GitHub provider" \
--attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository" \
--issuer-uri="https://token.actions.githubusercontent.com"
# Configure IAM policy binding
gcloud iam service-accounts add-iam-policy-binding "github-actions-deploy@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
--role="roles/iam.workloadIdentityUser" \
--member="principalSet://iam.googleapis.com/projects/YOUR_PROJECT_NUMBER/locations/global/workloadIdentityPools/github-actions-pool/subject/repo:YOUR_GITHUB_USERNAME/YOUR_REPO_NAME"
``` 

## 🌊 Deployment Flow

This repository implements a three-environment deployment strategy:

1. **Preview Environment** (`preview.yml`)
   - Deploys every PR to a unique URL
   - Automatically cleans up when PR is closed
   - Excludes develop → main PRs (handled by staging)

2. **Staging Environment** (`staging.yml`)
   - Deploys when PR is opened from `develop` to `main`
   - Uses a persistent staging instance

3. **Production Environment** (`production.yml`)
   - Deploys when code is merged to `main`
   - Uses Workload Identity Federation for enhanced security
