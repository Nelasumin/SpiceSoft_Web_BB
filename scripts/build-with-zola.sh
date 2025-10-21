#!/usr/bin/env bash
set -euo pipefail

REPO="getzola/zola"
ASSET="x86_64-unknown-linux-gnu.tar.gz"
VERSION="${ZOLA_VERSION:-}"
BIN_DIR=".bin"

get_download_url() {
  if [ -n "$VERSION" ]; then
    echo "https://github.com/${REPO}/releases/download/${VERSION}/zola-${VERSION}-${ASSET}"
    return
  fi
  echo "Resolving latest Zola release asset for ${ASSET}..."
  local url
  url=$(curl -fsSL https://api.github.com/repos/${REPO}/releases/latest \
    | grep -Eo "https://[^\"]+${ASSET}" \
    | head -n1 || true)
  if [ -n "$url" ]; then
    echo "$url"
  else
    local fallback="v0.19.2"
    echo "https://github.com/${REPO}/releases/download/${fallback}/zola-${fallback}-${ASSET}"
  fi
}

ZOLA_URL=$(get_download_url)
echo "Downloading Zola (Linux x86_64) from: ${ZOLA_URL}"
curl -fsSL -H "Accept: application/octet-stream" "${ZOLA_URL}" -o zola.tgz

echo "Verifying archive..."
if ! tar -tf zola.tgz >/dev/null 2>&1; then
  echo "Downloaded file is not a valid tar archive. First 200 bytes:"
  head -c 200 zola.tgz || true
  exit 2
fi

mkdir -p "${BIN_DIR}"
echo "Extracting Zola to ${BIN_DIR}/..."
tar -xzf zola.tgz -C "${BIN_DIR}"
chmod +x "${BIN_DIR}/zola" || true

echo "Zola version:"
"${BIN_DIR}/zola" --version || true

echo "Building site with Zola..."
"${BIN_DIR}/zola" build

echo "✅ Build completed. Output directory: ./public"