# Cloud Run Node.js Demo

This is a simple Node.js server that is deployed to Google Cloud Run.

## Prerequisites

- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- [Terraform](https://www.terraform.io/downloads)
- [Node.js](https://nodejs.org/en/download/)
- [pnpm](https://pnpm.io/installation)
- [Docker](https://docs.docker.com/get-docker/)

## GCP Setup

1. **Login and Set Project**
```bash
# Login to Google Cloud
gcloud auth application-default login

# Set your project ID
gcloud config set project ftc-performance-optimization
```

2. **Enable Required APIs**
```bash
# Enable Cloud Run API
gcloud services enable run.googleapis.com

# Enable Container Registry API
gcloud services enable containerregistry.googleapis.com
```

3. **Setup Service Account for Terraform**
```bash
# Create a service account
gcloud iam service-accounts create terraform-sa \
    --description="Service account for Terraform" \
    --display-name="Terraform SA"

# Grant necessary permissions
gcloud projects add-iam-policy-binding ftc-performance-optimization \
    --member="serviceAccount:terraform-sa@ftc-performance-optimization.iam.gserviceaccount.com" \
    --role="roles/editor"
```

4. **Configure Docker for GCP**
```bash
# Configure Docker to use Google Cloud credentials
gcloud auth configure-docker
```

## Deployment Steps

1. **Build and Push Docker Image**
```bash
# Build, tag, and push the image to Container Registry
pnpm docker:deploy
```

2. **Deploy Infrastructure**

For staging environment:
```bash
# Initialize Terraform
pnpm tf:init:staging

# Plan the deployment
pnpm tf:plan:staging

# Apply the changes
pnpm tf:apply:staging
```

For production environment:
```bash
pnpm tf:init:prod
pnpm tf:plan:prod
pnpm tf:apply:prod
```

## Available Scripts

- `pnpm start`: Start the Node.js server
- `pnpm dev`: Run the server in development mode
- `pnpm build`: Build the TypeScript project
- `pnpm watch`: Watch for TypeScript changes

### Docker Commands
- `pnpm docker:build`: Build the Docker image
- `pnpm docker:tag`: Tag the image for GCR
- `pnpm docker:push`: Push the image to GCR
- `pnpm docker:deploy`: Run all Docker commands in sequence

### Terraform Commands
- `pnpm tf:init:(staging|prod)`: Initialize Terraform
- `pnpm tf:plan:(staging|prod)`: Plan Terraform changes
- `pnpm tf:apply:(staging|prod)`: Apply Terraform changes
- `pnpm tf:destroy:(staging|prod)`: Destroy infrastructure (use with caution)