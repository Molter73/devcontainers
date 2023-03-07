FALCO_BUILDER_FLAVOR ?= fedora

.PHONY: build
build:
	docker build --tag falco-builder:$(FALCO_BUILDER_FLAVOR) \
		-f $(CURDIR)/$(FALCO_BUILDER_FLAVOR).Dockerfile \
		$(CURDIR)

.PHONY: deploy
deploy: build
	$(CURDIR)/format-spec.sh | kubectl apply -f -

.PHONY: teardown
teardown:
	$(CURDIR)/format-spec.sh | kubectl delete -f -
