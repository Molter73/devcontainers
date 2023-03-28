.PHONY: build
build:
	docker build --tag bpfd-devcontainer:latest $(CURDIR)

.PHONY: deploy
deploy: build
	envsubst < $(CURDIR)/bpfd.yml | kubectl apply -f -

.PHONY: teardown
teardown:
	envsubst < $(CURDIR)/bpfd.yml | kubectl delete -f -
