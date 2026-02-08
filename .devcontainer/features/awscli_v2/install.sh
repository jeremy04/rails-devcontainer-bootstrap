#!/bin/bash

set -euo pipefail

LOCALSTACK_CLI_VERSION="${LOCALSTACKVERSION:-4.5.0}"

echo "Installing AWS tools..."

# Install AWS CLI v2 via apk (Alpine native package)
apk add --no-cache aws-cli

# Detect architecture for LocalStack CLI binary
ARCH="$(uname -m)"
case "${ARCH}" in
  aarch64) LOCALSTACK_ARCH="linux-arm64" ;;
  x86_64)  LOCALSTACK_ARCH="linux-amd64" ;;
  *)       echo "Unsupported architecture: ${ARCH}" && exit 1 ;;
esac

curl -LO "https://github.com/localstack/localstack-cli/releases/download/v${LOCALSTACK_CLI_VERSION}/localstack-cli-${LOCALSTACK_CLI_VERSION}-${LOCALSTACK_ARCH}-onefile.tar.gz"
tar xzf "localstack-cli-${LOCALSTACK_CLI_VERSION}-${LOCALSTACK_ARCH}-onefile.tar.gz" -C /usr/local/bin
chmod +x /usr/local/bin/localstack
rm "localstack-cli-${LOCALSTACK_CLI_VERSION}-${LOCALSTACK_ARCH}-onefile.tar.gz"

# Configure dummy AWS credentials for LocalStack
mkdir -p /root/.aws
echo "[default]" > /root/.aws/credentials
echo "aws_access_key_id = dummy" >> /root/.aws/credentials
echo "aws_secret_access_key = dummy" >> /root/.aws/credentials
echo "[default]" > /root/.aws/config
echo "region = us-east-1" >> /root/.aws/config
echo "output = json" >> /root/.aws/config

echo "AWS tools installed successfully!"
