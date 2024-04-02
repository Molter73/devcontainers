.PHONY: all
all: build

.PHONY: build
build:
	docker build -t quay.io/mmoltras/devcontainers:os-uni \
		-f $(CURDIR)/Containerfile $(CURDIR)
