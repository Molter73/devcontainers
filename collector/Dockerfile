FROM quay.io/stackrox-io/collector-builder:cache

RUN dnf install -y \
        clang-tools-extra \
        clang-analyzer \
        podman-docker && \
    dnf clean all

COPY clangd.yaml /root/.config/clangd/config.yaml

# scan-view default port
EXPOSE 8181
