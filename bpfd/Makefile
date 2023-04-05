.PHONY: build
build:
	docker pull quay.io/mmoltras/devcontainers:bpfd || true
	docker build --tag quay.io/mmoltras/devcontainers:bpfd $(CURDIR)

.PHONY: deploy
deploy: build
	envsubst < $(CURDIR)/bpfd.yml | kubectl apply -f -

.PHONY: teardown
teardown:
	envsubst < $(CURDIR)/bpfd.yml | kubectl delete -f -
