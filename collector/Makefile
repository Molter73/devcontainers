BUILDER_IMAGE=quay.io/mmoltras/devcontainers:collector

.PHONY: build
build:
	docker build \
		--tag $(BUILDER_IMAGE)-$(SUFFIX) \
		-f Containerfile \
		$(CURDIR)

.PHONY: push
push: build
	docker push $(BUILDER_IMAGE)-$(SUFFIX)

.PHONY: teardown
teardown:
	docker rm -f collector-builder

.PHONY: tag-push-main
tag-push-main: build
	docker tag $(BUILDER_IMAGE)-$(SUFFIX) $(BUILDER_IMAGE)
	docker push $(BUILDER_IMAGE)

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
