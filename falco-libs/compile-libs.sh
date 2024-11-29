#!/usr/bin/env bash

set -euo pipefail

function clean () {
    rm -f "${LIBS_DIR}/driver/bpf/probe.{o,ll}"
    make -C "${LIBS_DIR}/build" clean || true
    rm -rf "${LIBS_DIR}/build"
}

function configure_host () {
    # sanitizers="-fsanitize=address -fsanitize=undefined"

    mkdir -p "${LIBS_DIR}/build"
    cmake \
        -DBUILD_BPF=ON \
        -DUSE_BUNDLED_DEPS=OFF \
        -DUSE_BUNDLED_VALIJSON=ON \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_LIBSCAP_MODERN_BPF=ON \
        -DUSE_BUNDLED_LIBBPF=OFF \
        -DUSE_BUNDLED_ZLIB=ON \
        -DUSE_BUNDLED_UTHASH=ON \
        -DUSE_BUNDLED_TINYDIR=ON \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
        -DCREATE_TEST_TARGETS=ON \
        -DUSE_SHARED_LIBELF=ON \
        -S "${LIBS_DIR}" \
        -B "${LIBS_DIR}/build"
}

function configure_emscripten () {
    emcmake cmake -DUSE_BUNDLED_DEPS=ON \
        -S "${LIBS_DIR}" \
        -B "${LIBS_DIR}/build"
}

function configure () {
    emscripten="${1:-0}"
    if ((emscripten)); then
        configure_emscripten
    else
        configure_host
    fi
}

function build () {
    local target
    local emscripten="${2:-0}"

    if [[ ! -d "${LIBS_DIR}/build" ]] || find "${LIBS_DIR}/build" -type d -empty | read -r ; then
        configure "$emscripten"
    fi

    target="$1"
    EMMAKE=""
    if ((emscripten)); then
        EMMAKE="emmake"
    fi
    eval "$EMMAKE" make -j"$(nproc)" -C "${LIBS_DIR}/build" "$target"
}

[[ -z "${LIBS_DIR}" ]] && LIBS_DIR="$(pwd)"
# We will be removing some directories, so go somewhere stable
cd "${LIBS_DIR}"

EMSCRIPTEN=0

while getopts "e" opt; do
    case "${opt}" in
        e)
            EMSCRIPTEN=1
            ;;
        ??)
            echo >&2 "Unknown option $OPTARG"
    esac
done

shift $(($OPTIND - 1))

ACTION="${1:-build}"
ACTION="${ACTION,,}"

TARGET="${2:-all}"

case "$ACTION" in
"clean")
    clean
    ;;
"configure")
    configure "$EMSCRIPTEN"
    ;;
"build")
    build "$TARGET" "$EMSCRIPTEN"
    ;;
"rebuild")
    clean
    build "$TARGET" "$EMSCRIPTEN"
    ;;
*)
    echo >&2 "Unknown option '$ACTION'"
    ;;
esac
