FALCO_BUILDER_FLAVOR ?= fedora

.PHONY: build
build:
	docker build --pull \
		--cache-from quay.io/mmoltras/devcontainers:falco-libs-$(FALCO_BUILDER_FLAVOR) \
		--tag quay.io/mmoltras/devcontainers:falco-libs-$(FALCO_BUILDER_FLAVOR) \
		-f $(CURDIR)/$(FALCO_BUILDER_FLAVOR).Dockerfile \
		$(CURDIR)

.PHONY: push
push: build
	docker push quay.io/mmoltras/devcontainers:falco-libs-$(FALCO_BUILDER_FLAVOR)

.PHONY: deploy
deploy: build
	$(CURDIR)/format-spec.sh | kubectl apply -f -

.PHONY: teardown
teardown:
	$(CURDIR)/format-spec.sh | kubectl delete -f -
