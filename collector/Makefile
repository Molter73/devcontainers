.PHONY: build
build:
	docker build --tag collector-devcontainer:latest $(CURDIR)

.PHONY: deploy
deploy: build
	envsubst < $(CURDIR)/collector.yml | kubectl apply -f -

.PHONY: teardown
teardown:
	envsubst < $(CURDIR)/collector.yml | kubectl delete -f -
