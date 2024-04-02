.PHONY: all
all: collector falco os-uni clean deploy

.PHONY: deploy
deploy:
	kluars xlate $(CURDIR)/lua | podman play kube -

.PHONY: clean
clean:
	kluars xlate $(CURDIR)/lua | podman play kube --down -

.PHONY: collector
collector:
	make -C collector build

.PHONY: falco
falco:
	make -C falco-libs build

.PHONY: os-uni
os-uni:
	make -C os-uni build
