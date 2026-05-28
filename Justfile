export fedora_release := env("FEDORA_RELEASE", "44")

default:
    @just --list

[group('Build')]
build-iso:
    #!/usr/bin/env bash
    set -euo pipefail
    if [[ "${UID}" -ne 0 ]]; then
        echo "Error: must run as root" >&2
        exit 1
    fi
    sudo bash build.sh

[group('Utility')]
clean:
    rm -rf output/
    rm -rf /tmp/fedora-hyprland-remix-build/

lint:
    shellcheck build.sh scripts/first-login-setup.sh

format:
    shfmt --write build.sh scripts/first-login-setup.sh
