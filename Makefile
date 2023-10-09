.PHONY: all
all: collector falco clean
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
