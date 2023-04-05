.PHONY: build
build:
	docker build --pull \
		--cache-from quay.io/mmoltras/devcontainers:collector \
		--tag quay.io/mmoltras/devcontainers:collector $(CURDIR)

.PHONY: push
push: build
	docker push quay.io/mmoltras/devcontainers:collector

.PHONY: deploy
deploy: build
	envsubst < $(CURDIR)/collector.yml | kubectl apply -f -

.PHONY: teardown
teardown:
	envsubst < $(CURDIR)/collector.yml | kubectl delete -f -
