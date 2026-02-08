#!/bin/bash

set -e

echo "Installing Fly.io tools..."

# Detect architecture for correct binary
ARCH="$(uname -m)"
case "${ARCH}" in
  aarch64) FLY_ARCH="arm64" ;;
  x86_64)  FLY_ARCH="x86_64" ;;
  *)       echo "Unsupported architecture: ${ARCH}" && exit 1 ;;
esac

# Download and install flyctl binary directly (avoids shell installer musl issues)
FLY_VERSION="$(curl -s https://api.github.com/repos/superfly/flyctl/releases/latest | grep '"tag_name"' | cut -d'"' -f4)"
curl -L "https://github.com/superfly/flyctl/releases/download/${FLY_VERSION}/flyctl_${FLY_VERSION#v}_Linux_${FLY_ARCH}.tar.gz" -o flyctl.tar.gz
tar xzf flyctl.tar.gz -C /usr/local/bin flyctl
chmod +x /usr/local/bin/flyctl
rm flyctl.tar.gz

echo "Fly.io tools installed successfully!"
