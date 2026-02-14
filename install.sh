#!/bin/bash
# AgentHarmony Installer Bootstrap
# This minimal script downloads and runs the full installer from GitHub Releases

set -e

REPO="rchiarino/AgentHarmony"
INSTALLER_URL="https://github.com/${REPO}/releases/latest/download/install-opencode.sh"

echo "🚀 AgentHarmony Installer"
echo "========================"

# Download to temp and execute
if command -v curl &> /dev/null; then
    curl -fsSL "$INSTALLER_URL" | bash
elif command -v wget &> /dev/null; then
    wget -qO- "$INSTALLER_URL" | bash
else
    echo "Error: curl or wget required"
    exit 1
fi
