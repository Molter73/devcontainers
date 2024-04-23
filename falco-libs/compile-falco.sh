#!/usr/bin/env bash

set -euo pipefail

function clean () {
    rm -f "${FALCO_DIR}/driver/bpf/probe.{o,ll}"
    make -C "${FALCO_DIR}/build" clean || true
    rm -rf "${FALCO_DIR}/build"
}

function configure_host () {
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

function configure_emscripten () {
    emcmake cmake -DUSE_BUNDLED_DEPS=ON \
        -S "${FALCO_DIR}" \
        -B "${FALCO_DIR}/build"
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

    if [[ ! -d "${FALCO_DIR}/build" ]] || find "${FALCO_DIR}/build" -type d -empty | read -r ; then
        configure "$emscripten"
    fi

    target="$1"
    EMMAKE=""
    if ((emscripten)); then
        EMMAKE="emmake"
    fi
    "$EMMAKE" make -j"$(nproc)" -C "${FALCO_DIR}/build" "$target"
}

[[ -z "${FALCO_DIR}" ]] && FALCO_DIR="$(pwd)"
# We will be removing some directories, so go somewhere stable
cd "${FALCO_DIR}"

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
