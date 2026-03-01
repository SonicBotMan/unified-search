# 统一搜索 🌐

> [English](./README.md) | [中文](./README_ZH.md)

一个强大的统一搜索工具，集成多个搜索引擎，支持智能源选择、去重、缓存和并行搜索。

## ✨ 功能特性

- 🔍 **智能源选择** - 根据查询语言自动选择最佳搜索引擎
  - 中文 → GLM webSearchPrime
  - 代码/GitHub → GitHub API
  - 通用 → SearXNG
- 🔄 **自动重试** - 失败时自动切换备选源
- 📦 **结果缓存** - 1小时缓存避免重复搜索
- 🗑️ **自动去重** - 自动移除重复结果
- ⏰ **时间筛选** - 按日期范围筛选结果
- ⚡ **并行搜索** - 同时搜索多个来源
- 📋 **统一格式** - 所有引擎结果格式标准化

## 🚀 快速开始

### 一键安装（推荐）

```bash
# 含 SearXNG 部署（推荐）
curl -sSL https://raw.githubusercontent.com/SonicBotMan/unified-search/main/install.sh | bash -s -- --with-searxng

# 基础安装
curl -sSL https://raw.githubusercontent.com/SonicBotMan/unified-search/main/install.sh | bash
```

### 手动安装

```bash
# 克隆仓库
git clone https://github.com/SonicBotMan/unified-search.git
cd unified-search

# 安装依赖
pip install -r requirements.txt

# 运行
python unified-search.py "你的搜索关键词"
```

## 🐳 SearXNG 部署（重要！）

SearXNG 是一个自托管的元搜索引擎，提供更好的隐私和控制。

### 方式1：Docker（推荐）

```bash
# 快速启动
docker run -d --name searxng -p 8888:8080 searxng/searxng:latest
```

### 方式2：Docker Compose

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

运行：`docker-compose up -d`

### 验证 SearXNG

```bash
curl -s http://localhost:8888 | head -20
```

如果看到 HTML 输出，说明 SearXNG 正在工作！

## 📖 使用方法

```bash
# 自动选择源（推荐）
python unified-search.py "AI 大模型新闻"

# 指定来源
python unified-search.py "python" -s searxng
python unified-search.py "chatgpt" -s github
python unified-search.py "科技新闻" -s glm

# 并行搜索所有来源
python unified-search.py "openai" -s all

# 按时间筛选（最近7天）
python unified-search.py "AI" -d 7

# 限制结果数量
python unified-search.py "新闻" -n 5

# 清除缓存
python unified-search.py --clear-cache
```

### 命令参数

| 参数 | 说明 | 默认值 |
|------|------|--------|
| `query` | 搜索关键词 | 必填 |
| `-s, --source` | 搜索来源 (auto/glm/searxng/github/all) | auto |
| `-n, --num` | 结果数量 | 10 |
| `-d, --days` | 时间筛选(天数) | 0 (不筛选) |
| `--no-dedup` | 禁用去重 | 启用 |
| `--clear-cache` | 清除缓存 | - |

## 🔧 配置说明

### 必需依赖

1. **Python 3.7+**
2. **mcporter** - MCP 服务器调用工具（可选，用于 GLM 搜索）
   ```bash
   npm install -g mcporter
   ```

3. **GLM webSearchPrime** - 中文搜索（可选，需要 API Key）
   - 获取 API Key：https://open.bigmodel.cn
   - 在 mcporter.json 中配置

4. **SearXNG** - 自托管元搜索引擎（可选但推荐）
   - 见上文部署说明

5. **GitHub API** - 代码搜索（公开仓库无需 Key）

### 可选：OpenClaw 集成

OpenClaw 用户可添加 skill：

```bash
# 复制到 OpenClaw skills
cp -r unified-search ~/.openclaw/workspace/skills/unified-search
```

## 📦 支持的搜索来源

| 来源 | 说明 | 需要 API Key |
|------|------|-------------|
| GLM webSearchPrime | 中文搜索（智谱AI） | 是 |
| SearXNG | 元搜索引擎 | 否 |
| GitHub | 代码仓库 | 否 |
| exa | 语义搜索 | 可选 |

## 🤝 致谢

本项目使用以下开源工具和服务：

- [mcporter](https://github.com/idea-statica/mcporter) - MCP 服务器客户端
- [GLM webSearchPrime](https://open.bigmodel.cn) - 智谱AI搜索API
- [SearXNG](https://github.com/searxng/searxng) - 自托管元搜索引擎
- [Jina AI](https://jina.ai) - 网页读取API
- [yt-dlp](https://github.com/yt-dlp/yt-dlp) - 视频/音频下载器
- [xreach](https://github.com/Panniantong/agent-reach) - Twitter/X CLI

## 📜 许可证

MIT License

## 👤 作者

SonicBotMan

---

英文文档见 [README.md](./README.md)
