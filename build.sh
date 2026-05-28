#!/usr/bin/env bash
# Build Fedora Hyprland Remix Live ISO
# Requires: root, livemedia-creator, pykickstart
# Run on: Fedora 44 (or compatible)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="/tmp/fedora-hyprland-remix-build"
OUTPUT_DIR="${SCRIPT_DIR}/output"
FEDORA_RELEASE="${FEDORA_RELEASE:-44}"
ISO_NAME="Fedora-Hyprland-Remix-${FEDORA_RELEASE}.iso"

# ── Check root ────────────────────────────────────────────────────────────────
if [[ "${EUID}" -ne 0 ]]; then
    echo "Error: This script must be run as root" >&2
    exit 1
fi

# ── Check dependencies ────────────────────────────────────────────────────────
for cmd in livemedia-creator pykickstart dnf; do
    if ! command -v "${cmd}" &>/dev/null; then
        echo "Error: '${cmd}' not found. Install with: dnf install lorax pykickstart" >&2
        exit 1
    fi
done

# ── Prepare build directory ───────────────────────────────────────────────────
echo ">>> Preparing build directory..."
rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
cp -a "${SCRIPT_DIR}/config" "${BUILD_DIR}/"
cp -a "${SCRIPT_DIR}/scripts" "${BUILD_DIR}/"
cp -a "${SCRIPT_DIR}/units" "${BUILD_DIR}/"

# ── Prepare output directory ──────────────────────────────────────────────────
mkdir -p "${OUTPUT_DIR}"

# ── Build ISO ─────────────────────────────────────────────────────────────────
echo ">>> Building Live ISO (Fedora ${FEDORA_RELEASE})..."
echo ">>> ISO will be saved to: ${OUTPUT_DIR}/${ISO_NAME}"

livemedia-creator \
    --ks "${SCRIPT_DIR}/fedora-hyprland.ks" \
    --no-virt \
    --project "Fedora-Hyprland-Remix" \
    --releasever "${FEDORA_RELEASE}" \
    --iso-only \
    --iso-name "${ISO_NAME}" \
    --resultdir "${OUTPUT_DIR}" \
    --ram 4096 \
    --vcpus 4

echo ">>> Build complete: ${OUTPUT_DIR}/${ISO_NAME}"

# ── Cleanup ───────────────────────────────────────────────────────────────────
rm -rf "${BUILD_DIR}"
echo ">>> Done."
