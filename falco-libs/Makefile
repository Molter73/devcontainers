.PHONY: build
build:
	docker build --tag falco-fedora:latest \
		-f $(CURDIR)/fedora.Dockerfile \
		$(CURDIR)

.PHONY: deploy
deploy: build
	envsubst < $(CURDIR)/falco.yml | kubectl apply -f -

.PHONY: teardown
teardown:
	envsubst < $(CURDIR)/falco.yml | kubectl delete -f -
