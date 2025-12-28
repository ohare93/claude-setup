---
name: docker
description: Use when checking Docker image versions or working with container registries. Skopeo is the required tool for registry queries - never parse Docker Hub web pages.
---

# Docker Image Version Checking

**CRITICAL**: Always use `skopeo` to check Docker image versions - never try to parse Docker Hub web pages or use browser scraping.

## Why Skopeo

- **Reliable**: Direct registry API access, not HTML parsing
- **Fast**: No JavaScript rendering or page loading
- **Comprehensive**: Works with all OCI-compliant registries
- **Accurate**: Gets data directly from registry without intermediaries

## List Available Tags

```bash
# Docker Hub (official images)
skopeo list-tags docker://library/nginx
skopeo list-tags docker://library/postgres

# Docker Hub (user images)
skopeo list-tags docker://username/image
skopeo list-tags docker://rommapp/romm

# Quay.io
skopeo list-tags docker://quay.io/organization/image

# GitHub Container Registry
skopeo list-tags docker://ghcr.io/owner/repo

# Custom registry (like Gitea)
skopeo list-tags docker://git.munchohare.com/jmo/image
```

## Inspect Specific Image/Tag

```bash
# Get detailed image information including labels, architecture, layers
skopeo inspect docker://rommapp/romm:4.3.2
skopeo inspect docker://git.munchohare.com/jmo/audioseek-frontend:0.1.11

# Inspect without pulling (faster)
skopeo inspect --no-tags docker://nginx:latest
```

## Registry URL Patterns

| Registry | URL Pattern |
|----------|-------------|
| Docker Hub (official) | `docker://library/<image>` |
| Docker Hub (user) | `docker://<user>/<image>` |
| Quay.io | `docker://quay.io/<org>/<image>` |
| GHCR | `docker://ghcr.io/<owner>/<repo>` |
| Custom | `docker://<registry>/<path>` |

## Common Use Cases

### Find Latest Version
```bash
# For semver tags (handles 1.10.0 > 1.9.0 correctly)
skopeo list-tags docker://rommapp/romm | jq -r '.Tags[]' | sort -V | tail -1
```

### Check If Tag Exists
```bash
skopeo inspect docker://nginx:1.25 &>/dev/null && echo "exists" || echo "not found"
```

### Compare Image Digests
```bash
skopeo inspect docker://nginx:latest | jq -r '.Digest'
skopeo inspect docker://nginx:1.25.3 | jq -r '.Digest'
```

### Get Image Architecture
```bash
skopeo inspect docker://nginx:latest | jq -r '.Architecture'
```
