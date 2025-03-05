BUILDER_IMAGE=quay.io/mmoltras/devcontainers:collector

.PHONY: build
build:
	docker build \
		--tag $(BUILDER_IMAGE) \
		--build-arg DEFAULT_GROUP=$(shell id -g) \
		--build-arg DEFAULT_USER=$(shell id -u) \
		-f Containerfile \
		$(CURDIR)

.PHONY: push
push: build
	docker push $(BUILDER_IMAGE)

.PHONY:teardown
teardown:
	docker rm -f collector-builder

.PHONY: deploy
deploy: build teardown
	docker run -idP --privileged --name devcontainers-collector-builder \
		--entrypoint /bin/bash \
		-e CMAKE_EXPORT_COMPILE_COMMANDS="ON" \
		-e COLLECTOR_HOST_ROOT="/host" \
		-v ${HOME}/go/src/github.com/stackrox/collector:${HOME}/go/src/github.com/stackrox/collector \
		-v /dev:/host/dev \
		-v /proc:/host/proc \
		-v /sys:/host/sys \
		-v /etc:/host/etc \
		-v /usr/lib:/host/usr/lib \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v collector-ccache:/root/.cache/ccache \
		-w ${HOME}/go/src/github.com/stackrox/collector \
		$(BUILDER_IMAGE)
