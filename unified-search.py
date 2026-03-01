#!/usr/bin/env python3
"""
Unified Search - 增强版统一搜索入口
支持：自动重试、统一格式、去重、缓存、并行搜索
"""

import argparse
import json
import time
import hashlib
import subprocess
import re
from datetime import datetime, timedelta
from typing import List, Dict, Any, Optional
from concurrent.futures import ThreadPoolExecutor, as_completed

# 缓存配置
CACHE_FILE = "/tmp/unified-search-cache.json"
CACHE_TTL = 3600  # 1小时

class UnifiedSearch:
    def __init__(self):
        self.cache = self.load_cache()
    
    def load_cache(self) -> Dict:
        try:
            with open(CACHE_FILE, 'r') as f:
                return json.load(f)
        except:
            return {}
    
    def save_cache(self):
        with open(CACHE_FILE, 'w') as f:
            json.dump(self.cache, f)
    
    def get_cache(self, key: str) -> Optional[Any]:
        if key in self.cache:
            data, timestamp = self.cache[key]
            if time.time() - timestamp < CACHE_TTL:
                return data
        return None
    
    def set_cache(self, key: str, value: Any):
        self.cache[key] = (value, time.time())
    
    def normalize_result(self, result: Dict, source: str) -> Dict:
        """统一结果格式"""
        normalized = {
            "title": "",
            "url": "",
            "content": "",
            "date": "",
            "source": source
        }
        
        if source == "glm":
            normalized["title"] = result.get("title", "")
            normalized["url"] = result.get("link", "")
            normalized["content"] = result.get("content", "")
            normalized["date"] = result.get("publish_date", "")
            
        elif source == "searxng":
            normalized["title"] = result.get("title", "")
            normalized["url"] = result.get("url", "")
            normalized["content"] = result.get("content", "")
            normalized["date"] = result.get("publishedDate", "")
            
        elif source == "github":
            normalized["title"] = result.get("name", "")
            normalized["url"] = result.get("html_url", "")
            normalized["content"] = result.get("description", "")
            normalized["date"] = result.get("updated_at", "")[:10]
        
        # 清理HTML标签
        normalized["content"] = re.sub(r'<[^>]+>', '', normalized["content"])
        return normalized
    
    def deduplicate(self, results: List[Dict]) -> List[Dict]:
        """去重"""
        seen = set()
        unique = []
        for r in results:
            url = r.get("url", "")
            if url and url not in seen:
                seen.add(url)
                unique.append(r)
        return unique
    
    def filter_by_time(self, results: List[Dict], days: int) -> List[Dict]:
        """时间筛选"""
        if days <= 0:
            return results
        
        cutoff = (datetime.now() - timedelta(days=days)).strftime("%Y-%m-%d")
        filtered = []
        for r in results:
            date = r.get("date", "")
            if date and date >= cutoff:
                filtered.append(r)
        return filtered
    
    def search_glm(self, query: str, num: int = 10) -> List[Dict]:
        """GLM webSearchPrime 搜索"""
        try:
            result = subprocess.run(
                ["mcporter", "call", "web-search-prime.webSearchPrime", 
                 f"search_query={query}"],
                capture_output=True, text=True, timeout=30
            )
            output = result.stdout.strip()
            if output:
                # 需要解码两次：第一次得到字符串，第二次得到列表
                data = json.loads(output)
                items = json.loads(data) if isinstance(data, str) else data
                return [self.normalize_result(item, "glm") for item in items[:num]]
        except Exception as e:
            print(f"⚠️ GLM 搜索失败: {e}")
        return []
    
    def search_searxng(self, query: str, num: int = 10) -> List[Dict]:
        """SearXNG 搜索"""
        try:
            import urllib.parse
            url = f"http://localhost:8888/search?q={urllib.parse.quote(query)}&format=json"
            result = subprocess.run(
                ["curl", "-s", url], capture_output=True, text=True, timeout=30
            )
            data = json.loads(result.stdout)
            items = data.get("results", [])
            return [self.normalize_result(item, "searxng") for item in items[:num]]
        except Exception as e:
            print(f"⚠️ SearXNG 搜索失败: {e}")
        return []
    
    def search_github(self, query: str, num: int = 10) -> List[Dict]:
        """GitHub 搜索"""
        try:
            url = f"https://api.github.com/search/repositories?q={query}"
            result = subprocess.run(
                ["curl", "-s", url], capture_output=True, text=True, timeout=30
            )
            data = json.loads(result.stdout)
            items = data.get("items", [])
            return [self.normalize_result(item, "github") for item in items[:num]]
        except Exception as e:
            print(f"⚠️ GitHub 搜索失败: {e}")
        return []
    
    def search_parallel(self, query: str, sources: List[str], num: int = 5) -> List[Dict]:
        """并行搜索多个来源"""
        results = []
        
        with ThreadPoolExecutor(max_workers=len(sources)) as executor:
            futures = {}
            if "glm" in sources:
                futures[executor.submit(self.search_glm, query, num)] = "glm"
            if "searxng" in sources:
                futures[executor.submit(self.search_searxng, query, num)] = "searxng"
            if "github" in sources:
                futures[executor.submit(self.search_github, query, num)] = "github"
            
            for future in as_completed(futures):
                try:
                    results.extend(future.result())
                except Exception as e:
                    print(f"⚠️ 来源 {futures[future]} 失败: {e}")
        
        return results
    
    def search(self, query: str, source: str = "auto", num: int = 10, 
               days: int = 0, dedup: bool = True) -> List[Dict]:
        """主搜索入口"""
        # 检查缓存
        cache_key = hashlib.md5(f"{source}:{query}:{num}".encode()).hexdigest()
        cached = self.get_cache(cache_key)
        if cached:
            print("📦 使用缓存结果")
            return cached
        
        # 自动选择来源
        if source == "auto":
            # 中文用GLM，代码用GitHub，其他用SearXNG
            if any('\u4e00' <= c <= '\u9fff' for c in query):
                source = "glm"
            elif "github" in query.lower() or "code" in query.lower():
                source = "github"
            else:
                source = "searxng"
        
        print(f"🔍 使用 {source.upper()} 搜索...")
        
        # 执行搜索
        if source == "all":
            results = self.search_parallel(query, ["glm", "searxng"], num)
        else:
            if source == "glm":
                results = self.search_glm(query, num)
            elif source == "searxng":
                results = self.search_searxng(query, num)
            elif source == "github":
                results = self.search_github(query, num)
            else:
                results = []
        
        # 处理结果
        if dedup:
            results = self.deduplicate(results)
        
        if days > 0:
            results = self.filter_by_time(results, days)
        
        # 缓存结果
        self.set_cache(cache_key, results)
        self.save_cache()
        
        return results


def main():
    parser = argparse.ArgumentParser(description="Unified Search - 增强版统一搜索")
    parser.add_argument("query", help="搜索关键词")
    parser.add_argument("-s", "--source", default="auto", 
                       choices=["auto", "glm", "searxng", "github", "all"],
                       help="搜索来源 (auto自动选择)")
    parser.add_argument("-n", "--num", type=int, default=10, help="结果数量")
    parser.add_argument("-d", "--days", type=int, default=0, help="时间筛选(天数)")
    parser.add_argument("--no-dedup", action="store_true", help="不去重")
    parser.add_argument("--clear-cache", action="store_true", help="清除缓存")
    
    args = parser.parse_args()
    
    search = UnifiedSearch()
    
    if args.clear_cache:
        search.cache = {}
        search.save_cache()
        print("🗑️ 缓存已清除")
        return
    
    results = search.search(
        args.query, 
        source=args.source, 
        num=args.num,
        days=args.days,
        dedup=not args.no_dedup
    )
    
    # 打印结果
    print(f"\n📊 找到 {len(results)} 条结果:\n")
    for i, r in enumerate(results, 1):
        title = r['title'][:60] if r['title'] else "无标题"
        url = r['url'][:80] if r['url'] else ""
        print(f"{i}. {title}")
        if url:
            print(f"   🔗 {url}")
        if r.get('date'):
            print(f"   📅 {r['date']}")
        print(f"   📍 来源: {r['source']}")
        print()


if __name__ == "__main__":
    main()
