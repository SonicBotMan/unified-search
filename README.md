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

### One-Click Installation

```bash
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

1. **mcporter** - For MCP server calls (GLM, exa, etc.)
   ```bash
   npm install -g mcporter
   ```

2. **GLM webSearchPrime** - Chinese search (requires API key)
   - Get API key from: https://open.bigmodel.cn
   - Configure in mcporter.json

3. **SearXNG** - Self-hosted meta search engine
   - Run locally or use public instance
   
4. **GitHub API** - For code search (no key required for public repos)

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
