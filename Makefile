# Variables
DOCKER_REGISTRY=langgenius
WEB_IMAGE=$(DOCKER_REGISTRY)/dify-web
API_IMAGE=$(DOCKER_REGISTRY)/dify-api
VERSION=dev
COMMIT_SHA=sky-$(VERSION)-$(shell git rev-parse HEAD)
LOG_LEVEL=DEBUG
# Build Docker images
build-web:
	@echo "Building web Docker image: $(WEB_IMAGE):$(VERSION)..."
	docker build -t $(WEB_IMAGE):$(VERSION) ./web
	@echo "Web Docker image built successfully: $(WEB_IMAGE):$(VERSION)"

build-api:
	@echo "Building API Docker image: $(API_IMAGE):$(VERSION)..."
	docker build -t $(API_IMAGE):$(VERSION) ./api --build-arg COMMIT_SHA=$(COMMIT_SHA)
	@echo "API Docker image built successfully: $(API_IMAGE):$(VERSION)"

# Push Docker images
push-web:
	@echo "Pushing web Docker image: $(WEB_IMAGE):$(VERSION)..."
	docker push $(WEB_IMAGE):$(VERSION)
	@echo "Web Docker image pushed successfully: $(WEB_IMAGE):$(VERSION)"

push-api:
	@echo "Pushing API Docker image: $(API_IMAGE):$(VERSION)..."
	docker push $(API_IMAGE):$(VERSION)
	@echo "API Docker image pushed successfully: $(API_IMAGE):$(VERSION)"

# Build all images
build-all: build-web build-api

# Push all images
push-all: push-web push-api

build-push-api: build-api push-api
build-push-web: build-web push-web

# Build and push all images
build-push-all: build-all push-all
	@echo "All Docker images have been built and pushed."

# Phony targets
.PHONY: build-web build-api push-web push-api build-all push-all build-push-all

build-restart-api: build-api
	export LOG_LEVEL=$(LOG_LEVEL)
	cd docker && docker-compose down api && docker-compose up -d api

build-restart-web: build-web
	export LOG_LEVEL=$(LOG_LEVEL)
	cd docker && docker-compose down web && docker-compose up -d web

build-restart-all: build-api build-web
	cd docker && docker-compose down && docker-compose up -d

