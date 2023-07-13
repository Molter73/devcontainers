FROM ubuntu:jammy

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        cmake \
        build-essential \
        clang \
        llvm \
        git \
        pkg-config \
        autoconf \
        automake \
        libtool \
        libelf-dev \
        wget \
        curl \
        kmod \
        lsb-release \
        gnupg \
        libb64-dev \
        libc-ares-dev \
        libcurl4-openssl-dev \
        libssl-dev \
        libtbb-dev \
        libjq-dev \
        libjsoncpp-dev \
        libgrpc++-dev \
        protobuf-compiler-grpc \
        libgtest-dev \
        libprotobuf-dev \
        liblua5.1-dev \
        libre2-dev \
        linux-headers-"$(uname -r)" \
        linux-tools-"$(uname -r)" \
        libbpf-dev \
        libcap-dev \
        vim \
        python3-pip && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y --no-install-recommends docker-ce-cli && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY compile-falco.sh /usr/bin/
