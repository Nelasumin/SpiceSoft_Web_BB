#!/usr/bin/env bash
set -euo pipefail

REPO="getzola/zola"
ASSET_SUFFIX="x86_64-unknown-linux-gnu.tar.gz"
FALLBACK_VERSION="${ZOLA_VERSION:-v0.19.2}"

echo "Resolving latest Zola release asset for ${ASSET_SUFFIX}..."
ZOLA_URL=$(curl -s https://api.github.com/repos/${REPO}/releases/latest \
  | grep -Eo "https://[^"]+${ASSET_SUFFIX}" \
  | head -n1 || true)

if [ -z "${ZOLA_URL}" ]; then
  echo "Latest asset not found via API, falling back to ${FALLBACK_VERSION}"
  ZOLA_URL="https://github.com/${REPO}/releases/download/${FALLBACK_VERSION}/zola-${FALLBACK_VERSION}-${ASSET_SUFFIX}"
fi

echo "Downloading Zola from: ${ZOLA_URL}"
curl -L "${ZOLA_URL}" -o zola.tgz

echo "Verifying archive..."
if ! tar -tf zola.tgz >/dev/null 2>&1; then
  echo "Downloaded file is not a valid tar archive. First 200 bytes:"
  head -c 200 zola.tgz || true
  exit 2
fi

echo "Extracting Zola..."
tar -xzf zola.tgz

echo "Zola version:"
./zola --version || true

echo "Building site with Zola..."
./zola build

echo "✅ Build completed. Output directory: ./public"