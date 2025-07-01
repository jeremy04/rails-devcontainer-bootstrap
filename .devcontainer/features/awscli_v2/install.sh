#!/bin/bash

set -euo pipefail

LOCALSTACK_CLI_VERSION="${LOCALSTACKVERSION:-4.5.0}"
AWSCLI_VERSION="${AWSCLIVERSION:-2.15.39}"

echo "Installing AWS tools..."
# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip" -o "awscliv2.zip" && \
unzip -q awscliv2.zip && \
./aws/install && \
rm -rf awscliv2.zip aws

curl -LO https://github.com/localstack/localstack-cli/releases/download/v${LOCALSTACK_CLI_VERSION}/localstack-cli-${LOCALSTACK_CLI_VERSION}-linux-amd64-onefile.tar.gz
tar xvzf localstack-cli-${LOCALSTACK_CLI_VERSION}-linux-amd64-onefile.tar.gz -C /usr/local/bin
chmod +x /usr/local/bin/localstack
rm localstack-cli-${LOCALSTACK_CLI_VERSION}-linux-amd64-onefile.tar.gz

# Configure dummy AWS credentials for LocalStack
mkdir -p /root/.aws
echo "[default]" > /root/.aws/credentials
echo "aws_access_key_id = dummy" >> /root/.aws/credentials
echo "aws_secret_access_key = dummy" >> /root/.aws/credentials
echo "[default]" > /root/.aws/config
echo "region = us-east-1" >> /root/.aws/config
echo "output = json" >> /root/.aws/config

echo "AWS tools installed successfully!"
