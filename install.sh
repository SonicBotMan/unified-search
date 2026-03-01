#!/bin/bash
# Unified Search - One-Click Installation Script
# Usage: curl -sSL https://raw.githubusercontent.com/SonicBotMan/unified-search/main/install.sh | bash

set -e

echo "🚀 Installing Unified Search..."

# Detect OS
OS="$(uname -s)"

# Create installation directory
INSTALL_DIR="${HOME}/.local/unified-search"
mkdir -p "${INSTALL_DIR}"

# Clone or download repository
echo "📦 Downloading Unified Search..."
if command -v git &> /dev/null; then
    if [ -d "${INSTALL_DIR}/.git" ]; then
        cd "${INSTALL_DIR}" && git pull
    else
        rm -rf "${INSTALL_DIR}"
        git clone https://github.com/SonicBotMan/unified-search.git "${INSTALL_DIR}"
    fi
else
    # Fallback: download as zip
    curl -sSL https://github.com/SonicBotMan/unified-search/archive/refs/heads/main.zip -o /tmp/unified-search.zip
    unzip -q /tmp/unified-search.zip -d "${HOME}/.local/"
    rm /tmp/unified-search.zip
    INSTALL_DIR="${HOME}/.local/unified-search-main"
fi

cd "${INSTALL_DIR}"

# Install Python dependencies
echo "🐍 Installing Python dependencies..."
pip install -r requirements.txt 2>/dev/null || pip3 install -r requirements.txt 2>/dev/null || pip install --user -r requirements.txt

# Install mcporter (if not installed)
if ! command -v mcporter &> /dev/null; then
    echo "📦 Installing mcporter..."
    npm install -g mcporter
fi

# Create symlink
echo "🔗 Creating symlink..."
ln -sf "${INSTALL_DIR}/unified-search.py" "${HOME}/bin/unified-search" 2>/dev/null || sudo ln -sf "${INSTALL_DIR}/unified-search.py" "/usr/local/bin/unified-search" 2>/dev/null || echo "⚠️ Could not create symlink, use: python ${INSTALL_DIR}/unified-search.py"

# Configure GLM (optional)
if [ ! -f "${HOME}/.openclaw/workspace/config/mcporter.json" ]; then
    echo ""
    echo "⚠️ GLM webSearchPrime requires API key configuration."
    echo "   Get your free API key at: https://open.bigmodel.cn"
    echo ""
fi

echo ""
echo "✅ Installation complete!"
echo ""
echo "📖 Usage:"
echo "   python ${INSTALL_DIR/unified-search.py} \"your search query\""
echo ""
echo "🔧 Next steps:"
echo "   1. Configure GLM API key (optional): https://open.bigmodel.cn"
echo "   2. Start SearXNG (optional): docker run -d -p 8888:8080 searxng/searxng"
echo ""
