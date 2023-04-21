.PHONY: deploy-kind
deploy-kind:
	kind create cluster --config $(CURDIR)/config.yml

.PHONY: teardown-kind
teardown-kind:
	kind delete cluster --name devcontainers
