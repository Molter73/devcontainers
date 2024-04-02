FROM quay.io/stackrox-io/collector-builder:master

RUN dnf install -y epel-release && \
    dnf install -y \
        ccache \
        clang-tools-extra \
        clang-analyzer \
        podman-docker && \
    dnf clean all && \
    ln -s $(which ccache) /usr/local/bin/gcc && \
    ln -s $(which ccache) /usr/local/bin/g++ && \
    echo "" > /etc/profile.d/ccache.sh && \
    echo 'export MAKEFLAGS="-j$(nproc)"' >> /root/.bashrc

ENV CC=/usr/local/bin/gcc
ENV CXX=/usr/local/bin/g++

COPY clangd.yaml /root/.config/clangd/config.yaml

# scan-view default port
EXPOSE 8181
