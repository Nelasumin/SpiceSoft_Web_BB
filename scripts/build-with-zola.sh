#!/usr/bin/env bash
set -euo pipefail

echo "Downloading Zola (Linux x86_64)..."
curl -L https://github.com/getzola/zola/releases/latest/download/zola-x86_64-unknown-linux-gnu.tar.gz -o zola.tgz

echo "Extracting Zola..."
tar -xzf zola.tgz

echo "Zola version:"
./zola --version || true

echo "Building site with Zola..."
./zola build

echo "✅ Build completed. Output directory: ./public"