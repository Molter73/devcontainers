.PHONY: build
build:
	docker pull quay.io/stackrox-io/collector-builder:cache

.PHONY: deploy
deploy: build
	envsubst < $(CURDIR)/collector.yml | kubectl apply -f -

.PHONY: teardown
teardown:
	envsubst < $(CURDIR)/collector.yml | kubectl delete -f -
