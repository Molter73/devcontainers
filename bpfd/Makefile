BUILDER_IMAGE=quay.io/mmoltras/devcontainers:bpfd

.PHONY: build
build:
	docker build \
		--tag $(BUILDER_IMAGE) $(CURDIR)

.PHONY: push
push: build
	docker push $(BUILDER_IMAGE)

.PHONY: deploy
deploy:
	envsubst < $(CURDIR)/bpfd.yml | kubectl apply -f -

.PHONY: teardown
teardown:
	envsubst < $(CURDIR)/bpfd.yml | kubectl delete -f -

.PHONY: docker-teardown
docker-teardown:
	docker rm -f bpfd-builder

.PHONY: docker-deploy
docker-deploy: build docker-teardown
	docker run -id --privileged --name bpfd-builder \
		-e CARGO_TARGET_DIR=/root/target \
		-v ${HOME}/go/src/github.com/redhat-et/bpfd:${HOME}/go/src/github.com/redhat-et/bpfd \
		-v ${HOME}/go/src/github.com/libbpf/libbpf:${HOME}/go/src/github.com/libbpf/libbpf \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v /sys:/sys \
		-v /mnt/podman/cargo-cache:/usr/local/cargo/registry \
		-v /mnt/podman/bpfd-cache:/root/target \
		-w ${HOME}/go/src/github.com/redhat-et/bpfd \
		$(BUILDER_IMAGE)
