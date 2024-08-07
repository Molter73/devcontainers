FROM fedora:40

RUN dnf install -y \
    gcc \
    gcc-c++ \
    ccache \
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
# Dependencies for falcosecurity/testing
    golang \
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
    xz \
    zlib-devel && \
    dnf clean all && \
# Set some symlinks to allow building of drivers.
    kernel_version=$(uname -r) && \
    ln -s "/host/lib/modules/$kernel_version" "/lib/modules/$kernel_version" && \
    ln -s "/host/usr/src/kernels/$kernel_version" "/usr/src/kernels/$kernel_version" && \
    ln -s $(which ccache) /usr/local/bin/gcc && \
    ln -s $(which ccache) /usr/local/bin/g++ && \
    echo "" > /etc/profile.d/ccache.sh

# Install docker CLI
RUN dnf config-manager --add-repo \
    https://download.docker.com/linux/fedora/docker-ce.repo && \
    dnf install -y docker-ce-cli && \
    dnf clean all

# Install emscripten
RUN git clone https://github.com/emscripten-core/emsdk.git && \
    cd emsdk && ./emsdk install latest && \
    ./emsdk activate latest && \
    echo 'export EMSDK_QUIET=1' >> /root/.bashrc && \
    echo 'source /emsdk/emsdk_env.sh' >> /root/.bashrc

ENV CC=/usr/local/bin/gcc
ENV CXX=/usr/local/bin/g++

COPY clangd.yaml /root/.config/clangd/config.yaml
COPY compile-falco.sh /usr/local/bin/
COPY compile-libs.sh /usr/local/bin/
