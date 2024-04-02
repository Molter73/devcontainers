DEVCONTAINER_IMAGE=quay.io/mmoltras/devcontainers:os-uni

.PHONY: all
all: build

.PHONY: build
build:
	docker build -t $(DEVCONTAINER_IMAGE) \
		-f $(CURDIR)/Containerfile $(CURDIR)

.PHONY: push
push: build
	docker push $(DEVCONTAINER_IMAGE)
