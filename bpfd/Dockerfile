FROM fedora:41

ENV RUSTUP_HOME=/usr/local/rustup
ENV CARGO_HOME=/usr/local/cargo
ENV GOPATH=/root/go
ENV PATH=/usr/local/cargo/bin:$PATH:$GOPATH/bin

RUN dnf -y update && \
	dnf -y install \
		perl \
		bpftool \
		dnf-plugins-core \
		libbpf-devel \
		iproute \
		iproute-tc \
		iputils \
		elfutils-libelf-devel \
		golang \
		protobuf-compiler \
		llvm-devel \
		clang-devel && \
		dnf clean all

# Install docker CLI
RUN dnf config-manager --add-repo \
	https://download.docker.com/linux/fedora/docker-ce.repo && \
	dnf install -y docker-ce-cli && \
	dnf clean all

RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28 && \
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2 && \
	go install github.com/cilium/ebpf/cmd/bpf2go@main

RUN curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | \
	sh -s -- -y --no-modify-path && \
	chmod -R a+w $RUSTUP_HOME $CARGO_HOME && \
	rustup toolchain install nightly --component clippy,rustfmt,rust-src && \
	cargo install bpf-linker
