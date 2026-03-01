# 统一搜索 🌐

> 智能搜索助手。任何查询，任何来源。

强大的统一搜索工具，集成多个搜索引擎，支持智能源选择。

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.7+](https://img.shields.io/badge/Python-3.7+-blue.svg)](https://www.python.org/)

## 功能特性

- 🔍 **智能选择** - 自动选择最佳引擎（中文→GLM，代码→GitHub，通用→SearXNG）
- ⚡ **并行搜索** - 同时搜索多个来源
- 📦 **缓存** - 1小时缓存避免重复搜索
- 🗑️ **去重** - 自动移除重复结果
- ⏰ **时间筛选** - 按日期范围筛选

## 快速开始

```bash
# 一键安装（含 SearXNG）
curl -sSL https://raw.githubusercontent.com/SonicBotMan/unified-search/main/install.sh | bash -s -- --with-searxng

# 或克隆运行
git clone https://github.com/SonicBotMan/unified-search.git
cd unified-search
pip install -r requirements.txt
python unified-search.py "AI 新闻"
```

## 使用方法

```bash
# 自动选择源（推荐）
python unified-search.py "AI 大模型"

# 指定来源
python unified-search.py "python" -s searxng
python unified-search.py "chatgpt" -s github
python unified-search.py "科技" -s glm

# 搜索所有来源
python unified-search.py "openai" -s all

# 按时间筛选（最近7天）
python unified-search.py "AI" -d 7
```

## 参数

| 参数 | 说明 |
|------|------|
| `-s, --source` | 搜索来源 (auto/glm/searxng/github/all) |
| `-n, --num` | 结果数量 |
| `-d, --days` | 时间筛选(天数) |
| `--clear-cache` | 清除缓存 |

## SearXNG 部署

SearXNG 提供隐私保护的本地搜索。

```bash
# Docker（推荐）
docker run -d --name searxng -p 8888:8080 searxng/searxng:latest
```

或使用安装脚本：`install.sh --with-searxng`

## 配置

### GLM API（可选）

1. 获取 API Key：https://open.bigmodel.cn
2. 复制配置：`cp references/mcporter-sample.json ~/.openclaw/workspace/config/mcporter.json`
3. 添加你的 API Key

## 支持的来源

| 来源 | 说明 | API Key |
|------|------|---------|
| GLM | 中文搜索 | 需要 |
| SearXNG | 元搜索 | 否 |
| GitHub | 代码搜索 | 否 |

## 文档

- [English README](./README.md)
- [愿景](./VISION.md)
- [贡献指南](./CONTRIBUTING.md)
- [安全](./SECURITY.md)

## 许可证

MIT License - 见 [LICENSE](./LICENSE)
