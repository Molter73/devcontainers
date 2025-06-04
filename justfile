all: collector falco clean deploy

collector:
    just collector/

falco:
    just falco-libs/

clean:
    kluars xlate `pwd`/lua | podman play kube --down -

deploy:
    kluars xlate `pwd`/lua | podman play kube -
