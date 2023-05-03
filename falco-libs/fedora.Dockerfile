FROM fedora:38

RUN dnf install -y \
    gcc \
    gcc-c++ \
    libasan \
    libubsan \
    bpftool \
    libbpf-devel \
    dnf-plugins-core \
    git \
    make \
    cmake \
    autoconf \
    automake \
    pkg-config \
    patch \
    ncurses-devel \
    libtool \
    elfutils-libelf-devel \
    diffutils \
    which \
    perl-core \
    clang \
    procps \
    python3-pip \
    kmod \
# Debugging packages
    gdb \
    clang-analyzer \
    clang-tools-extra \
# Dependencies needed to build falcosecurity/libs.
    libb64-devel \
    c-ares-devel \
    libcurl.x86_64 \
    libcurl-devel.x86_64 \
    grpc-cpp \
    grpc-devel \
    grpc-plugins \
    jq-devel \
    jsoncpp-devel \
    openssl-devel \
    tbb-devel \
    zlib-devel && \
    dnf clean all && \
# Set some symlinks to allow building of drivers.
    kernel_version=$(uname -r) && \
    ln -s "/host/lib/modules/$kernel_version" "/lib/modules/$kernel_version" && \
    ln -s "/host/usr/src/kernels/$kernel_version" "/usr/src/kernels/$kernel_version"

# Install docker CLI
RUN dnf config-manager --add-repo \
    https://download.docker.com/linux/fedora/docker-ce.repo && \
    dnf install -y docker-ce-cli && \
    dnf clean all

COPY compile-falco.sh /usr/bin/
