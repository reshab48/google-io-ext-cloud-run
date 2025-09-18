.PHONY: help venv install run docker-build docker-run clean test deploy delete-service lint format

# Variables
VENV = venv
PYTHON = $(VENV)/bin/python
PIP = $(VENV)/bin/pip
FLASK = $(VENV)/bin/flask
GUNICORN = $(VENV)/bin/gunicorn
PROJECT_ID ?= gdg-x-gccd-extended-event
APP_NAME ?= cloud-run-demo
PORT = 8080

# Default target
help:
	@echo "Available commands:"
	@echo "  make venv        - Create virtual environment"
	@echo "  make install     - Install dependencies in virtual environment"
	@echo "  make run         - Run Flask app locally with development server"
	@echo "  make run-prod    - Run Flask app with Gunicorn (production-like)"
	@echo "  make docker-build - Build Docker image"
	@echo "  make docker-run  - Run Docker container locally"
	@echo "  make clean       - Remove virtual environment and cache files"
	@echo "  make test        - Run tests (if any)"
	@echo "  make deploy      - Deploy to Cloud Run using gcloud"
	@echo "  make delete-service - Delete Cloud Run service from GCP"
	@echo "  make lint        - Run code linting"
	@echo "  make format      - Format code"
	@echo "  make all         - Setup venv and install dependencies"

# Create virtual environment
venv:
	@echo "Creating virtual environment..."
	python3 -m venv $(VENV)
	@echo "Virtual environment created at $(VENV)"
	@echo "Run 'make install' to install dependencies"

# Install dependencies
install: venv
	@echo "Installing dependencies..."
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt
	@echo "Dependencies installed successfully"

# Run Flask app locally (development)
run: install
	@echo "Starting Flask development server..."
	PORT=$(PORT) $(PYTHON) app.py

# Run Flask app with Gunicorn (production-like)
run-prod: install
	@echo "Starting Gunicorn server..."
	$(GUNICORN) --bind :$(PORT) --workers 1 --threads 8 --timeout 0 app:app

# Build Docker image
docker-build:
	@echo "Building Docker image..."
	docker build -t $(APP_NAME) .
	@echo "Docker image built: $(APP_NAME)"

# Run Docker container locally
docker-run: docker-build
	@echo "Running Docker container..."
	docker run -p $(PORT):$(PORT) -e PORT=$(PORT) $(APP_NAME)

# Clean up virtual environment and cache files
clean:
	@echo "Cleaning up..."
	rm -rf $(VENV)
	rm -rf __pycache__
	rm -rf *.pyc
	rm -rf .pytest_cache
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	@echo "Cleanup complete"

# Run tests (placeholder - add actual test command when tests are created)
test: install
	@echo "No tests configured yet"
	@echo "Add test files and update this target"

# Deploy to Cloud Run using source
deploy:
	@echo "Deploying to Cloud Run..."
	gcloud run deploy $(APP_NAME) \
		--source . \
		--platform managed \
		--region us-central1 \
		--allow-unauthenticated \
		--project $(PROJECT_ID) \
		--port $(PORT)

# Deploy using Cloud Build
deploy-build:
	@echo "Deploying using Cloud Build..."
	gcloud builds submit --config cloudbuild.yaml --project $(PROJECT_ID)

# Delete Cloud Run service
delete-service:
	@echo "Deleting Cloud Run service $(APP_NAME) from project $(PROJECT_ID)..."
	gcloud run services delete $(APP_NAME) \
		--platform managed \
		--region us-central1 \
		--project $(PROJECT_ID) \
		--quiet
	@echo "Service deleted successfully"

# Lint code (install and use flake8)
lint: install
	@echo "Installing linting tools..."
	$(PIP) install flake8
	@echo "Running flake8..."
	$(VENV)/bin/flake8 app.py --max-line-length=100 --exclude=$(VENV)

# Format code (install and use black)
format: install
	@echo "Installing formatting tools..."
	$(PIP) install black
	@echo "Formatting code with black..."
	$(VENV)/bin/black app.py --line-length=100

# Setup everything (default target for initial setup)
all: venv install
	@echo "Setup complete! Run 'make run' to start the development server"