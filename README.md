# Serverless on GCP: Getting Started with Cloud Run

## Google I/O Extended Demo Application

This is a simple Flask application created for demonstrating how to deploy applications on Google Cloud Run during the Google I/O Extended event.

### 📚 Educational Purpose

This repository serves as a hands-on example for students learning about serverless computing on Google Cloud Platform, specifically focusing on Cloud Run.

### 🎯 Learning Objectives

- Understanding serverless architecture
- Deploying containerized applications to Cloud Run
- Working with Flask applications in a cloud environment
- Best practices for Cloud Run deployments

### 🚀 Quick Start

#### Using Make Commands (Recommended)

```bash
# Initial setup - creates venv and installs dependencies
make all

# Run development server
make run

# Run production-like server with Gunicorn
make run-prod

# Build and run with Docker
make docker-run

# See all available commands
make help
```

#### Manual Setup

1. **Create and activate virtual environment:**
   ```bash
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

3. **Run the application:**
   ```bash
   python app.py
   ```

4. **Access the application:**
   - Open your browser to `http://localhost:8080`
   - Try the personalized route: `http://localhost:8080/hello/YourName`
   - Check health status: `http://localhost:8080/health`

#### Using Docker Locally

```bash
# Using Make
make docker-build  # Build image
make docker-run    # Build and run

# Or manually
docker build -t cloud-run-demo .
docker run -p 8080:8080 -e PORT=8080 cloud-run-demo
```

### 📦 Application Structure

- `app.py` - Main Flask application with health check endpoint
- `requirements.txt` - Python dependencies (Flask, Gunicorn)
- `Makefile` - Automation for common tasks and venv management
- `Dockerfile` - Container configuration for Cloud Run
- `.dockerignore` - Docker build ignore rules
- `cloudbuild.yaml` - Cloud Build configuration for automated deployment
- `.gitignore` - Git ignore rules

### 🌐 Routes

- `/` - Returns welcome message for Google I/O Extended
- `/hello/<name>` - Returns a personalized greeting
- `/health` - Health check endpoint for monitoring

### 🔐 Google Cloud Setup

#### 1. Install gcloud SDK

Follow the official installation guide for your operating system:
- [gcloud SDK Installation Guide](https://cloud.google.com/sdk/docs/install)

**Quick Install Options:**

- **macOS**: `brew install google-cloud-sdk`
- **Ubuntu/Debian**:
  ```bash
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
  sudo apt-get update && sudo apt-get install google-cloud-cli
  ```
- **Windows**: Download and run the [installer](https://cloud.google.com/sdk/docs/install#windows)

#### 2. Authenticate with Google Cloud

```bash
# Login to your Google Cloud account
gcloud auth login

# This will open your browser for authentication
```

#### 3. Configure Your Project

```bash
# Set your default project (replace with your project ID)
gcloud config set project gdg-x-gccd-extended-event

# Verify the project is set
gcloud config list project

# Get your project's default service account (for Cloud Build)
gcloud builds get-default-service-account --project gdg-x-gccd-extended-event
```

#### 4. Enable Required APIs

```bash
# Enable Cloud Run API
gcloud services enable run.googleapis.com

# Enable Cloud Build API (for automated deployments)
gcloud services enable cloudbuild.googleapis.com

# Enable Container Registry API
gcloud services enable containerregistry.googleapis.com
```

#### 5. Set Default Region (Optional but Recommended)

```bash
# Set default region for Cloud Run
gcloud config set run/region us-central1
```

### 🏗️ Deployment to Cloud Run

#### Option 1: Using Make Command (Simplest)
```bash
# Deploy directly from source
make deploy

# Or deploy using Cloud Build
make deploy-build
```

#### Option 2: Using Cloud Build
```bash
gcloud builds submit --config cloudbuild.yaml
```

#### Option 3: Manual Deployment
```bash
# Build the Docker image
docker build -t gcr.io/YOUR_PROJECT_ID/cloud-run-demo .

# Push to Container Registry
docker push gcr.io/YOUR_PROJECT_ID/cloud-run-demo

# Deploy to Cloud Run
gcloud run deploy cloud-run-demo \
  --image gcr.io/YOUR_PROJECT_ID/cloud-run-demo \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

#### Option 4: Direct Deployment from Source
```bash
gcloud run deploy cloud-run-demo \
  --source . \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

### 🛠️ Available Make Commands

```bash
make help           # Show all available commands
make venv           # Create virtual environment
make install        # Install dependencies in venv
make run            # Run Flask dev server
make run-prod       # Run with Gunicorn (production-like)
make docker-build   # Build Docker image
make docker-run     # Build and run Docker container
make clean          # Remove venv and cache files
make deploy         # Deploy to Cloud Run
make delete-service # Delete Cloud Run service from GCP
make lint           # Run code linting
make format         # Format code with black
make all            # Initial setup (venv + install)
```

### 📝 Prerequisites

- Python 3.9+
- Make (usually pre-installed on Linux/Mac)
- Docker (for containerization)
- Google Cloud Account (for deployment)
- gcloud CLI (for deployment) - [Installation Guide](https://cloud.google.com/sdk/docs/install)

### 👥 Target Audience

Students and developers new to:
- Serverless computing
- Google Cloud Platform
- Container-based deployments

### 📖 Resources

- [Google Cloud Run Documentation](https://cloud.google.com/run/docs)
- [Flask Documentation](https://flask.palletsprojects.com/)
- [Google I/O Extended](https://io.google/extended/)

---

**Created for Google I/O Extended Event**
Topic: *Serverless on GCP: Getting Started with Cloud Run*