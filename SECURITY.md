# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.1.x   | ✅                 |
| 1.0.x   | ✅                 |
| < 1.0   | ❌                 |

## Reporting a Vulnerability

If you find a security vulnerability, please open a GitHub Issue with tag "security".

## Security Best Practices

### API Keys

- **Never commit API keys** to the repository
- Use environment variables or config files outside of git
- The `references/mcporter-sample.json` shows the config format - never put real keys there

### Local Deployment

- SearXNG runs locally - your searches stay private
- Cache is stored in `/tmp/` - cleared on reboot by default
- No data is sent to external servers (except search engine APIs)

### Docker

- Run SearXNG in a container for isolation
- Don't expose SearXNG to the public internet without authentication
- Use Docker's built-in security features

## Privacy

- This tool sends queries to third-party search APIs (GLM, GitHub, SearXNG instances)
- Each service has its own privacy policy
- For maximum privacy, run your own SearXNG instance

## Updates

Check for updates regularly:
```bash
git pull origin main
```
