FALCO_BUILDER_FLAVOR ?= fedora

.PHONY: build
build:
	docker build \
		--tag quay.io/mmoltras/devcontainers:falco-libs-$(FALCO_BUILDER_FLAVOR) \
		-f $(CURDIR)/$(FALCO_BUILDER_FLAVOR).Dockerfile \
		$(CURDIR)

.PHONY: push
push: build
	docker push quay.io/mmoltras/devcontainers:falco-libs-$(FALCO_BUILDER_FLAVOR)

.PHONY: deploy
deploy: build
	$(CURDIR)/format-spec.sh | kubectl apply -f -

.PHONY: teardown
teardown:
	$(CURDIR)/format-spec.sh | kubectl delete -f -

.PHONY: docker-teardown
docker-teardown:
	docker rm -f libs-builder

.PHONY: docker-deploy
docker-deploy: build docker-teardown
	docker run -id --privileged --name libs-builder \
		-e CMAKE_EXPORT_COMPILE_COMMANDS="ON" \
		-e HOST_ROOT="/host" \
		-e FALCO_DIR="${HOME}/go/src/github.com/falcosecurity/libs" \
		-e FALCO_BUILDER_FLAVOR="${FALCO_BUILDER_FLAVOR}" \
		-w ${HOME}/go/src/github.com/falcosecurity/libs \
		-v ${HOME}/go/src/github.com/falcosecurity/libs:${HOME}/go/src/github.com/falcosecurity/libs \
		-v /usr/src:/usr/src \
		-v /lib/modules:/lib/modules \
		-v /dev:/host/dev \
		-v /proc:/host/proc \
		-v /sys:/host/sys \
		-v /etc:/host/etc \
		-v /usr/lib:/host/usr/lib \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v /run/podman/podman.sock:/run/podman/podman.sock \
		quay.io/mmoltras/devcontainers:falco-libs-$(FALCO_BUILDER_FLAVOR)
