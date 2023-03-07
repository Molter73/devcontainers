#!/usr/bin/env bash

set -euo pipefail

FALCO_BUILDER_FLAVOR="${FALCO_BUILDER_FLAVOR:-fedora}" \
    envsubst < "${PWD}/falco.yml"
