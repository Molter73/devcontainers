BUILDER_IMAGE = quay.io/mmoltras/devcontainers:tpa

.PHONY: build
build:
	podman build --tag $(BUILDER_IMAGE) $(CURDIR)

.PHONY: deploy
deploy: build
	podman run -id --name tpa-uni-builder \
		-v ${HOME}/go/src/github.com/molter73/tpa-uni:${HOME}/go/src/github.com/molter73/tpa-uni \
		-w ${HOME}/go/src/github.com/molter73/tpa-uni \
		$(BUILDER_IMAGE)

.PHONY: teardown
teardown:
	podman rm -f tpa-uni-builder
