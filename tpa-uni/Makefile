BUILDER_IMAGE = quay.io/mmoltras/devcontainers:tpa

.PHONY: build
build:
	docker build --tag $(BUILDER_IMAGE) $(CURDIR)

.PHONY: push
push: build
	docker push $(BUILDER_IMAGE)

.PHONY: deploy
deploy: build
	docker run -id --name tpa-uni-builder \
		-v ${HOME}/go/src/github.com/molter73/tpa-uni:${HOME}/go/src/github.com/molter73/tpa-uni \
		-w ${HOME}/go/src/github.com/molter73/tpa-uni \
		$(BUILDER_IMAGE)

.PHONY: teardown
teardown:
	docker rm -f tpa-uni-builder
