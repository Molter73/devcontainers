#!/usr/bin/env bash

set -euo pipefail

function clean () {
    make -C "${FALCO_DIR}/build" clean || true
    rm -rf "${FALCO_DIR}/build"
}

function configure() {
    # sanitizers="-fsanitize=address -fsanitize=undefined"

    mkdir -p "${FALCO_DIR}/build"
cmake -DUSE_BUNDLED_DEPS=OFF
    cmake \
        -DBUILD_BPF=ON \
        -DUSE_BUNDLED_DEPS=OFF \
        -DUSE_BUNDLED_NLOHMANN_JSON=ON \
        -DUSE_BUNDLED_YAMLCPP=ON \
        -DUSE_BUNDLED_CPPHTTPLIB=ON \
        -DUSE_BUNDLED_CXXOPTS=ON \
        -DFALCOSECURITY_LIBS_SOURCE_DIR="${LIBS_DIR}" \
        -DDRIVER_SOURCE_DIR="${LIBS_DIR}" \
        -DBUILD_DRIVER=ON \
        -DBUILD_FALCO_MODERN_BPF=ON \
        -DCREATE_TEST_TARGETS=ON \
        -DBUILD_FALCO_UNIT_TESTS=ON \
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

shift $(($OPTIND - 1))

ACTION="${1:-build}"
ACTION="${ACTION,,}"

TARGET="${2:-all}"

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
