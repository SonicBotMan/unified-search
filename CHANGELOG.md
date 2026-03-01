# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2026-03-01

### ✨ Added
- Initial release
- Smart source selection (auto-detect Chinese/English/code)
- GLM webSearchPrime integration (Chinese search)
- SearXNG integration (general search)
- GitHub API integration (code search)
- Result caching (1-hour TTL)
- Automatic deduplication
- Time-based filtering
- Parallel search (all sources)
- Unified result format

### 🔧 Features
- `--source` / `-s`: Specify search source
- `--num` / `-n`: Limit results
- `--days` / `-d`: Filter by time
- `--clear-cache`: Clear cached results
- `--no-dedup`: Disable deduplication

### 🤝 Dependencies
- mcporter (MCP client)
- GLM webSearchPrime (Zhipu AI)
- SearXNG
- GitHub API
- Jina AI (optional)
- yt-dlp (optional)
