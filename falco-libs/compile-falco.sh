#!/usr/bin/env bash

set -euo pipefail

ACTION="${1:-build}"
ACTION="${ACTION,,}"

TARGET="${2:-all}"

function clean () {
    rm -f "${FALCO_DIR}/driver/bpf/probe.{o,ll}"
    make -C "${FALCO_DIR}/build" clean || true
    rm -rf "${FALCO_DIR}/build"
}

function configure () {
    # sanitizers="-fsanitize=address -fsanitize=undefined"
    use_bundled_libbpf="OFF"
    build_shared_libs="OFF"

    if [[ "${FALCO_BUILDER_FLAVOR:-fedora}" != "fedora" ]] ; then
        # Platform dependent adjustments
        use_bundled_libbpf="ON"
    else
        build_shared_libs="ON"
    fi

    mkdir -p "${FALCO_DIR}/build"
    cmake \
        -DBUILD_BPF=ON \
        -DUSE_BUNDLED_DEPS=OFF \
        -DUSE_BUNDLED_VALIJSON=ON \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_LIBSCAP_MODERN_BPF=ON \
        -DUSE_BUNDLED_LIBBPF="${use_bundled_libbpf}" \
        -DUSE_BUNDLED_ZLIB=ON \
        -DUSE_BUNDLED_UTHASH=ON \
        -DUSE_BUNDLED_TINYDIR=ON \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
        -DCREATE_TEST_TARGETS=ON \
        -DBUILD_SHARED_LIBS="${build_shared_libs}" \
        -S "${FALCO_DIR}" \
        -B "${FALCO_DIR}/build"
}

function build () {
    local target

    if [[ ! -d "${FALCO_DIR}/build" ]] || find "${FALCO_DIR}/build" -type d -empty | read -r ; then
        configure
    fi

    target="$1"
    make -j"$(nproc)" -C "${FALCO_DIR}/build" "$target"
}

[[ -z "${FALCO_DIR}" ]] && FALCO_DIR="$(pwd)"
# We will be removing some directories, so go somewhere stable
cd "${FALCO_DIR}"

case "$ACTION" in
"clean")
    clean
    ;;
"configure")
    configure
    ;;
"build")
    build "$TARGET"
    ;;
"rebuild")
    clean
    build "$TARGET"
    ;;
*)
    echo >&2 "Unknown option '$ACTION'"
    ;;
esac
