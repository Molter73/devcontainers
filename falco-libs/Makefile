.PHONY: clang-config
clang-config:
	envsubst < $(CURDIR)/clangd.tpl.yaml > $(CURDIR)/clangd.yaml

.PHONY: clean
clean:
	rm -f $(CURDIR)/clangd.yaml

.PHONY: build
build: clang-config
	docker build \
		--tag quay.io/mmoltras/devcontainers:falco-libs \
		--build-arg DEFAULT_GROUP=$(shell id -g) \
		--build-arg DEFAULT_USER=$(shell id -u) \
		-f Containerfile \
		$(CURDIR)

.PHONY: push
push: build
	docker push quay.io/mmoltras/devcontainers:falco-libs

.PHONY: teardown
teardown: clean
	docker rm -f libs-builder

.PHONY: deploy
deploy: build teardown
	docker run -id --privileged --name libs-builder \
		-e CMAKE_EXPORT_COMPILE_COMMANDS="ON" \
		-e HOST_ROOT="/host" \
		-e FALCO_DIR="${HOME}/go/src/github.com/falcosecurity/libs" \
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
		-v /run/podman/podman.sock:/host/run/podman/podman.sock \
		quay.io/mmoltras/devcontainers:falco-libs
