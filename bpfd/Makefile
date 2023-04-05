.PHONY: build
build:
	docker build --pull \
		--cache-from quay.io/mmoltras/devcontainers:bpfd \
		--tag quay.io/mmoltras/devcontainers:bpfd $(CURDIR)

.PHONY: push
push: build
	docker push quay.io/mmoltras/devcontainers:bpfd

.PHONY: deploy
deploy: build
	envsubst < $(CURDIR)/bpfd.yml | kubectl apply -f -

.PHONY: teardown
teardown:
	envsubst < $(CURDIR)/bpfd.yml | kubectl delete -f -
