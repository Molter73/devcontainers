FROM quay.io/stackrox-io/collector-builder:cache

RUN dnf install -y \
        clang-tools-extra \
        clang-analyzer \
        podman-docker && \
    dnf clean all

# scan-view default port
EXPOSE 8181
