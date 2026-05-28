#!/usr/bin/env bash
# Build Fedora Hyprland Remix Live ISO
# Requires: root, livecd-tools
# Run on: Fedora 44 (or compatible)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${SCRIPT_DIR}/output"
FEDORA_RELEASE="${FEDORA_RELEASE:-44}"
ISO_NAME="Fedora-Hyprland-Remix-${FEDORA_RELEASE}.iso"

# ── Check root ────────────────────────────────────────────────────────────────
if [[ "${EUID}" -ne 0 ]]; then
    echo "Error: This script must be run as root" >&2
    exit 1
fi

# ── Check dependencies ────────────────────────────────────────────────────────
for cmd in livecd-creator; do
    if ! command -v "${cmd}" &>/dev/null; then
        echo "Error: '${cmd}' not found. Install with: dnf install livecd-tools" >&2
        exit 1
    fi
done

# ── Prepare output directory ──────────────────────────────────────────────────
mkdir -p "${OUTPUT_DIR}"
mkdir -p /var/cache/live

# ── Build ISO ─────────────────────────────────────────────────────────────────
echo ">>> Building Live ISO (Fedora ${FEDORA_RELEASE})..."
echo ">>> ISO will be saved to: ${OUTPUT_DIR}/${ISO_NAME}"

livecd-creator \
    --config "${SCRIPT_DIR}/fedora-hyprland.ks" \
    --fslabel "Fedora-Hyprland-Remix-${FEDORA_RELEASE}" \
    --cache /var/cache/live

mv -f "${ISO_NAME}" "${OUTPUT_DIR}/"

echo ">>> Build complete: ${OUTPUT_DIR}/${ISO_NAME}"
echo ">>> Done."
