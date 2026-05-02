#!/usr/bin/env bash
# Publish layernull.de via scp
# Usage: ./publish.sh

set -euo pipefail

REMOTE_USER="webjg68sz_xyty27"
REMOTE_HOST="213.160.71.2"
REMOTE_PORT="2244"
REMOTE_PATH="html/layernull.de/"

SCRIPT_NAME="$(basename "$0")"
SRC_DIR="$(cd "$(dirname "$0")" && pwd)"

cd "$SRC_DIR"

echo "[*] Source : $SRC_DIR"
echo "[*] Target : ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_PATH} (port ${REMOTE_PORT})"
echo "[*] Excluded: .git/, ${SCRIPT_NAME}"
echo

# Build a clean staging dir so scp -r uploads only what we want
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

# Copy everything except .git and the script itself into staging
# (uses tar to preserve structure with excludes)
tar --exclude='.git' \
    --exclude="${SCRIPT_NAME}" \
    --exclude='publish.sh' \
    -cf - . | tar -xf - -C "$STAGE"

# Upload contents of staging dir
scp -P "$REMOTE_PORT" -r "$STAGE"/. "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_PATH}"

echo
echo "[+] Publish complete."
