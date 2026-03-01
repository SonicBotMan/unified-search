# Unified Search 🌐

> Your intelligent search companion. Any query. Any source.

A powerful unified search tool that integrates multiple search engines with smart source selection.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.7+](https://img.shields.io/badge/Python-3.7+-blue.svg)](https://www.python.org/)

## Features

- 🔍 **Smart Selection** - Auto-selects best engine (Chinese→GLM, Code→GitHub, General→SearXNG)
- ⚡ **Parallel Search** - Search multiple sources simultaneously  
- 📦 **Caching** - 1-hour cache to avoid redundant searches
- 🗑️ **Deduplication** - Removes duplicate results
- ⏰ **Time Filter** - Filter by date range

## Quick Start

```bash
# One-click install (with SearXNG)
curl -sSL https://raw.githubusercontent.com/SonicBotMan/unified-search/main/install.sh | bash -s -- --with-searxng

# Or clone and run
git clone https://github.com/SonicBotMan/unified-search.git
cd unified-search
pip install -r requirements.txt
python unified-search.py "AI news"
```

## Usage

```bash
# Auto-select source (recommended)
python unified-search.py "AI 大模型"

# Specify source
python unified-search.py "python" -s searxng
python unified-search.py "chatgpt" -s github
python unified-search.py "科技" -s glm

# Search all sources
python unified-search.py "openai" -s all

# Filter by time (last 7 days)
python unified-search.py "AI" -d 7
```

## Options

| Option | Description |
|--------|-------------|
| `-s, --source` | Search source (auto/glm/searxng/github/all) |
| `-n, --num` | Number of results |
| `-d, --days` | Filter by days |
| `--clear-cache` | Clear cache |

## SearXNG Setup

SearXNG provides privacy-preserving local search.

```bash
# Docker (recommended)
docker run -d --name searxng -p 8888:8080 searxng/searxng:latest
```

Or use the install script: `install.sh --with-searxng`

## Configuration

### GLM API (Optional)

1. Get API key: https://open.bigmodel.cn
2. Copy config: `cp references/mcporter-sample.json ~/.openclaw/workspace/config/mcporter.json`
3. Add your API key

## Supported Sources

| Source | Description | API Key |
|--------|-------------|---------|
| GLM | Chinese search | Required |
| SearXNG | Meta search | No |
| GitHub | Code search | No |

## Documentation

- [中文文档](./README_ZH.md)
- [Vision](./VISION.md)
- [Contributing](./CONTRIBUTING.md)
- [Security](./SECURITY.md)

## License

MIT License - See [LICENSE](./LICENSE)
