#!/bin/bash

set -e

echo "Installing Fly.io tools..."
curl -L https://fly.io/install.sh | sh
mv /root/.fly/bin/flyctl /usr/local/bin/
chmod +x /usr/local/bin/flyctl
echo "Fly.io tools installed successfully!"
