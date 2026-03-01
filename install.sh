#!/bin/bash
# Unified Search - One-Click Installation Script
# Usage: curl -sSL https://raw.githubusercontent.com/SonicBotMan/unified-search/main/install.sh | bash

set -e

echo "🚀 Installing Unified Search..."

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Detect OS
OS="$(uname -s)"
ARCH="$(uname -m)"

# Create installation directory
INSTALL_DIR="${HOME}/.local/unified-search"
mkdir -p "${INSTALL_DIR}"

# Clone or download repository
echo "📦 Downloading Unified Search..."
if command -v git &> /dev/null; then
    if [ -d "${HOME}/.local/unified-search/.git" ]; then
        cd "${HOME}/.local/unified-search" && git pull
    else
        rm -rf "${HOME}/.local/unified-search"
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
    if command -v npm &> /dev/null; then
        npm install -g mcporter
    else
        echo -e "${YELLOW}⚠️ npm not found, skipping mcporter installation${NC}"
    fi
fi

# Create symlink
echo "🔗 Creating symlink..."
mkdir -p "${HOME}/bin"
if [ -w "${HOME}/bin" ] || [ -w "/usr/local/bin" ]; then
    ln -sf "${INSTALL_DIR}/unified-search.py" "${HOME}/bin/unified-search" 2>/dev/null || \
    sudo ln -sf "${INSTALL_DIR}/unified-search.py" "/usr/local/bin/unified-search" 2>/dev/null || \
    echo "⚠️ Could not create symlink"
    echo "   Use: python ${INSTALL_DIR}/unified-search.py"
fi

# ========== SearXNG Installation ==========
echo ""
echo "🐳 Setting up SearXNG (optional but recommended)..."

install_searxng() {
    if command -v docker &> /dev/null; then
        echo "📦 Installing SearXNG via Docker..."
        
        # Check if container already exists
        if docker ps -a | grep -q searxng; then
            if docker ps | grep -q searxng; then
                echo -e "${GREEN}✅ SearXNG is already running${NC}"
            else
                echo "Starting existing SearXNG container..."
                docker start searxng
            fi
        else
            # Create directories
            mkdir -p "${HOME}/.local/searxng/data"
            mkdir -p "${HOME}/.local/searxng/config"
            
            # Run SearXNG container
            docker run -d \
                --name searxng \
                --restart unless-stopped \
                -p 8888:8080 \
                -v "${HOME}/.local/searxng/data:/etc/searxng/data" \
                -v "${HOME}/.local/searxng/config:/etc/searxng/settings.d" \
                -e SEARXNG_BASE_URL="http://localhost:8888" \
                searxng/searxng:latest
            
            echo -e "${GREEN}✅ SearXNG installed and running on port 8888${NC}"
        fi
        
        # Verify
        sleep 2
        if curl -s http://localhost:8888 > /dev/null; then
            echo -e "${GREEN}✅ SearXNG is accessible at http://localhost:8888${NC}"
        else
            echo -e "${YELLOW}⚠️ SearXNG container started but not yet responding${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️ Docker not found. To install SearXNG:${NC}"
        echo "   1. Install Docker: https://docs.docker.com/get-docker"
        echo "   2. Run: docker run -d --name searxng -p 8888:8080 searxng/searxng:latest"
    fi
}

# Ask user
if [ "$1" = "--with-searxng" ] || [ "$1" = "-s" ]; then
    install_searxng
else
    echo ""
    echo -e "${YELLOW}Optional: Install SearXNG for better search results?${NC}"
    echo "   Run with: $0 --with-searxng"
    echo "   Or: $0 -s"
fi

# ========== Configuration ==========
echo ""
echo "📝 Configuration..."
if [ ! -f "${HOME}/.openclaw/workspace/config/mcporter.json" ]; then
    echo -e "${YELLOW}⚠️ GLM webSearchPrime requires API key configuration.${NC}"
    echo "   Get your free API key at: https://open.bigmodel.cn"
    echo ""
    echo "   Copy the sample config:"
    echo "   cp ${INSTALL_DIR}/references/mcporter-sample.json ~/.openclaw/workspace/config/mcporter.json"
    echo "   Then edit with your API key."
else
    echo -e "${GREEN}✅ mcporter config found${NC}"
fi

echo ""
echo "========================================"
echo -e "${GREEN}✅ Installation complete!${NC}"
echo "========================================"
echo ""
echo "📖 Usage:"
echo "   python ${INSTALL_DIR}/unified-search.py \"your search query\""
echo ""
echo "🔧 Next steps:"
echo "   1. Configure GLM API key (optional): https://open.bigmodel.cn"
echo "   2. Test search: python ${INSTALL_DIR}/unified-search.py \"AI news\""
echo ""
