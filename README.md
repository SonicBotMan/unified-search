# Unified Search 🌐

> [English](./README.md) | [中文](./README_ZH.md)

A powerful unified search tool that integrates multiple search engines with smart source selection, deduplication, caching, and parallel search capabilities.

## ✨ Features

- 🔍 **Smart Source Selection** - Auto-selects best search engine based on query language
  - Chinese → GLM webSearchPrime
  - Code/GitHub → GitHub API
  - General → SearXNG
- 🔄 **Auto Retry** - Falls back to alternative sources on failure
- 📦 **Result Caching** - 1-hour cache to avoid redundant searches
- 🗑️ **Deduplication** - Removes duplicate results automatically
- ⏰ **Time Filter** - Filter results by date range
- ⚡ **Parallel Search** - Search multiple sources simultaneously
- 📋 **Unified Format** - Standardized result format across all engines

## 🚀 Quick Start

### One-Click Installation (Recommended)

```bash
# With SearXNG included (recommended)
curl -sSL https://raw.githubusercontent.com/SonicBotMan/unified-search/main/install.sh | bash -s -- --with-searxng

# Basic installation
curl -sSL https://raw.githubusercontent.com/SonicBotMan/unified-search/main/install.sh | bash
```

### Manual Installation

```bash
# Clone the repository
git clone https://github.com/SonicBotMan/unified-search.git
cd unified-search

# Install dependencies
pip install -r requirements.txt

# Run
python unified-search.py "your search query"
```

## 🐳 SearXNG Setup (Important!)

SearXNG is a self-hosted metasearch engine that provides better privacy and control.

### Option 1: Docker (Recommended)

```bash
# Quick start with Docker
docker run -d --name searxng -p 8888:8080 searxng/searxng:latest
```

### Option 2: Docker Compose

```yaml
# docker-compose.yml
version: '3'
services:
  searxng:
    image: searxng/searxng:latest
    container_name: searxng
    ports:
      - "8888:8080"
    environment:
      - SEARXNG_BASE_URL=http://localhost:8888
    restart: unless-stopped
```

Then run: `docker-compose up -d`

### Verify SearXNG

```bash
curl -s http://localhost:8888 | head -20
```

If you see HTML output, SearXNG is working!

## 📖 Usage

```bash
# Auto-select source (recommended)
python unified-search.py "AI 大模型新闻"

# Specify source
python unified-search.py "python" -s searxng
python unified-search.py "chatgpt" -s github
python unified-search.py "科技新闻" -s glm

# Search all sources in parallel
python unified-search.py "openai" -s all

# Filter by time (last 7 days)
python unified-search.py "AI" -d 7

# Limit results
python unified-search.py "news" -n 5

# Clear cache
python unified-search.py --clear-cache
```

### Command Options

| Option | Description | Default |
|--------|-------------|---------|
| `query` | Search keyword | Required |
| `-s, --source` | Search source (auto/glm/searxng/github/all) | auto |
| `-n, --num` | Number of results | 10 |
| `-d, --days` | Filter by days | 0 (no filter) |
| `--no-dedup` | Disable deduplication | Enabled |
| `--clear-cache` | Clear cache | - |

## 🔧 Configuration

### Required Dependencies

1. **Python 3.7+**
2. **mcporter** - For MCP server calls (optional, for GLM search)
   ```bash
   npm install -g mcporter
   ```

3. **GLM webSearchPrime** - Chinese search (optional, requires API key)
   - Get API key from: https://open.bigmodel.cn
   - Configure in mcporter.json

4. **SearXNG** - Self-hosted meta search engine (optional but recommended)
   - See Setup section above

5. **GitHub API** - For code search (no key required for public repos)

### Optional: OpenClaw Integration

For OpenClaw users, add the skill:

```bash
# Copy to OpenClaw skills
cp -r unified-search ~/.openclaw/workspace/skills/unified-search
```

## 📦 Supported Search Sources

| Source | Description | API Key Required |
|--------|-------------|------------------|
| GLM webSearchPrime | Chinese search (Zhipu AI) | Yes |
| SearXNG | Meta search engine | No |
| GitHub | Code repositories | No |
| exa | Semantic search | Optional |

## 🤝 Acknowledgments

This project uses the following open-source tools and services:

- [mcporter](https://github.com/idea-statica/mcporter) - MCP server client
- [GLM webSearchPrime](https://open.bigmodel.cn) - Zhipu AI search API
- [SearXNG](https://github.com/searxng/searxng) - Self-hosted meta search engine
- [Jina AI](https://jina.ai) - Reader API for webpage extraction
- [yt-dlp](https://github.com/yt-dlp/yt-dlp) - Video/audio downloader
- [xreach](https://github.com/Panniantong/agent-reach) - Twitter/X CLI

## 📜 License

MIT License

## 👤 Author

SonicBotMan

---

For Chinese documentation, see [README_ZH.md](./README_ZH.md)
