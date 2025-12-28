#!/usr/bin/env python3
"""
Codebase Analyzer for Claude Code Sandbox Configuration

This script analyzes a codebase to detect:
- Primary technology stack(s)
- Package managers and dependencies
- Frameworks and libraries
- Docker/container usage
- Sensitive file patterns
- Git configuration

Output: JSON report for sandbox configuration decisions
"""

import json
import os
import sys
from pathlib import Path
from typing import Any


def analyze_codebase(root_path: str = ".") -> dict[str, Any]:
    """Analyze codebase and return detection results."""
    root = Path(root_path).resolve()

    result = {
        "stacks": [],
        "package_managers": [],
        "frameworks": [],
        "dev_tools": [],
        "docker": False,
        "docker_compose": False,
        "git": {
            "detected": False,
            "ssh_remote": False,
            "https_remote": False
        },
        "sensitive_files": [],
        "domains_needed": [],
        "excluded_commands": [],
        "recommendations": []
    }

    # Detect stacks by manifest files
    stack_indicators = {
        "package.json": "nodejs",
        "requirements.txt": "python",
        "pyproject.toml": "python",
        "setup.py": "python",
        "Pipfile": "python",
        "Cargo.toml": "rust",
        "go.mod": "go",
        "composer.json": "php",
        "Gemfile": "ruby",
        "pom.xml": "java",
        "build.gradle": "java",
        "build.gradle.kts": "kotlin",
        "*.csproj": "dotnet",
        "mix.exs": "elixir",
        "pubspec.yaml": "dart",
        "Package.swift": "swift"
    }

    for indicator, stack in stack_indicators.items():
        if indicator.startswith("*"):
            # Glob pattern
            if list(root.glob(f"**/{indicator}")):
                if stack not in result["stacks"]:
                    result["stacks"].append(stack)
        else:
            if (root / indicator).exists():
                if stack not in result["stacks"]:
                    result["stacks"].append(stack)

    # Detect package managers
    pm_indicators = {
        "package-lock.json": "npm",
        "yarn.lock": "yarn",
        "pnpm-lock.yaml": "pnpm",
        "bun.lockb": "bun",
        "requirements.txt": "pip",
        "Pipfile.lock": "pipenv",
        "poetry.lock": "poetry",
        "uv.lock": "uv",
        "Cargo.lock": "cargo",
        "go.sum": "go",
        "composer.lock": "composer",
        "Gemfile.lock": "bundler"
    }

    for indicator, pm in pm_indicators.items():
        if (root / indicator).exists():
            if pm not in result["package_managers"]:
                result["package_managers"].append(pm)

    # Detect frameworks (Node.js)
    if "nodejs" in result["stacks"] and (root / "package.json").exists():
        try:
            with open(root / "package.json") as f:
                pkg = json.load(f)
                deps = {**pkg.get("dependencies", {}), **pkg.get("devDependencies", {})}

                framework_map = {
                    "next": "nextjs",
                    "nuxt": "nuxt",
                    "react": "react",
                    "vue": "vue",
                    "svelte": "svelte",
                    "@angular/core": "angular",
                    "express": "express",
                    "fastify": "fastify",
                    "nestjs": "nestjs",
                    "@nestjs/core": "nestjs",
                    "hono": "hono"
                }

                for dep, framework in framework_map.items():
                    if dep in deps and framework not in result["frameworks"]:
                        result["frameworks"].append(framework)

                # Detect dev tools
                dev_tools_map = {
                    "jest": "jest",
                    "vitest": "vitest",
                    "mocha": "mocha",
                    "vite": "vite",
                    "webpack": "webpack",
                    "esbuild": "esbuild",
                    "turbo": "turbo",
                    "typescript": "typescript",
                    "eslint": "eslint",
                    "prettier": "prettier"
                }

                for dep, tool in dev_tools_map.items():
                    if dep in deps and tool not in result["dev_tools"]:
                        result["dev_tools"].append(tool)
        except (json.JSONDecodeError, IOError):
            pass

    # Detect Python frameworks
    if "python" in result["stacks"]:
        req_files = ["requirements.txt", "pyproject.toml", "setup.py"]
        content = ""
        for req_file in req_files:
            if (root / req_file).exists():
                try:
                    with open(root / req_file) as f:
                        content += f.read().lower()
                except IOError:
                    pass

        py_frameworks = {
            "django": "django",
            "fastapi": "fastapi",
            "flask": "flask",
            "starlette": "starlette",
            "tornado": "tornado",
            "pyramid": "pyramid"
        }

        for dep, framework in py_frameworks.items():
            if dep in content and framework not in result["frameworks"]:
                result["frameworks"].append(framework)

        py_tools = {
            "pytest": "pytest",
            "ruff": "ruff",
            "black": "black",
            "mypy": "mypy",
            "flake8": "flake8"
        }

        for dep, tool in py_tools.items():
            if dep in content and tool not in result["dev_tools"]:
                result["dev_tools"].append(tool)

    # Detect Docker
    docker_files = ["Dockerfile", "docker-compose.yml", "docker-compose.yaml", "compose.yml", "compose.yaml"]
    for df in docker_files:
        if (root / df).exists():
            if "dockerfile" in df.lower():
                result["docker"] = True
            else:
                result["docker_compose"] = True

    # Check .docker directory
    if (root / ".docker").is_dir():
        result["docker"] = True

    # Detect git configuration
    if (root / ".git").exists():
        result["git"]["detected"] = True
        git_config = root / ".git" / "config"
        if git_config.exists():
            try:
                with open(git_config) as f:
                    config_content = f.read()
                    if "git@" in config_content or "ssh://" in config_content:
                        result["git"]["ssh_remote"] = True
                    if "https://" in config_content:
                        result["git"]["https_remote"] = True
            except IOError:
                pass

    # Detect sensitive files
    sensitive_patterns = [
        ".env",
        ".env.local",
        ".env.production",
        ".env.development",
        "secrets/",
        "credentials.py",
        "*.pem",
        "*.key",
        "wp-config.php",
        "config/master.key",
        "appsettings.Production.json",
        ".npmrc",
        ".pypirc"
    ]

    for pattern in sensitive_patterns:
        if pattern.endswith("/"):
            if (root / pattern.rstrip("/")).is_dir():
                result["sensitive_files"].append(pattern.rstrip("/"))
        elif "*" in pattern:
            if list(root.glob(pattern)):
                result["sensitive_files"].append(pattern)
        else:
            if (root / pattern).exists():
                result["sensitive_files"].append(pattern)

    # Generate domain recommendations
    domain_map = {
        "npm": ["registry.npmjs.org"],
        "yarn": ["registry.npmjs.org", "registry.yarnpkg.com"],
        "pnpm": ["registry.npmjs.org"],
        "pip": ["pypi.org", "files.pythonhosted.org"],
        "poetry": ["pypi.org", "files.pythonhosted.org"],
        "uv": ["pypi.org", "files.pythonhosted.org"],
        "cargo": ["crates.io", "static.crates.io", "index.crates.io"],
        "go": ["proxy.golang.org", "sum.golang.org"],
        "composer": ["packagist.org", "repo.packagist.org"],
        "bundler": ["rubygems.org", "api.rubygems.org"]
    }

    for pm in result["package_managers"]:
        if pm in domain_map:
            for domain in domain_map[pm]:
                if domain not in result["domains_needed"]:
                    result["domains_needed"].append(domain)

    # Add github.com for common cases
    if result["git"]["detected"]:
        result["domains_needed"].append("github.com")

    # Generate excluded commands recommendations
    if result["docker"] or result["docker_compose"]:
        result["excluded_commands"].extend(["docker", "docker-compose"])

    # Check for Kubernetes
    k8s_files = ["kubernetes/", "k8s/", "helm/", "Chart.yaml"]
    for kf in k8s_files:
        if kf.endswith("/"):
            if (root / kf.rstrip("/")).is_dir():
                result["excluded_commands"].extend(["kubectl", "helm"])
                break
        elif (root / kf).exists():
            result["excluded_commands"].extend(["kubectl", "helm"])
            break

    # Generate recommendations
    web_frameworks = ["nextjs", "nuxt", "react", "vue", "svelte", "angular", "django", "fastapi", "flask"]
    has_web_framework = any(fw in result["frameworks"] for fw in web_frameworks)

    if has_web_framework:
        result["recommendations"].append({
            "setting": "network.allowLocalBinding",
            "value": True,
            "reason": f"Web framework detected ({', '.join([f for f in result['frameworks'] if f in web_frameworks])}). Dev servers need to bind localhost ports."
        })

    if "jest" in result["dev_tools"]:
        result["recommendations"].append({
            "setting": "jest_watchman",
            "value": "use --no-watchman flag",
            "reason": "Jest detected. Watch mode requires --no-watchman flag in sandbox."
        })

    if result["git"]["ssh_remote"]:
        result["recommendations"].append({
            "setting": "network.allowUnixSockets",
            "value": "Add SSH agent socket path",
            "reason": "SSH git remotes detected. Add SSH agent socket to allowUnixSockets for push/pull."
        })

    # Remove duplicates from excluded_commands
    result["excluded_commands"] = list(set(result["excluded_commands"]))

    return result


def main():
    """Main entry point."""
    root_path = sys.argv[1] if len(sys.argv) > 1 else "."

    result = analyze_codebase(root_path)

    # Print human-readable summary
    print("=" * 60)
    print("CODEBASE ANALYSIS REPORT")
    print("=" * 60)

    print(f"\n📦 Detected Stacks: {', '.join(result['stacks']) or 'None detected'}")
    print(f"📋 Package Managers: {', '.join(result['package_managers']) or 'None detected'}")
    print(f"🔧 Frameworks: {', '.join(result['frameworks']) or 'None detected'}")
    print(f"🛠️  Dev Tools: {', '.join(result['dev_tools']) or 'None detected'}")

    print(f"\n🐳 Docker: {'Yes' if result['docker'] else 'No'}")
    print(f"🐳 Docker Compose: {'Yes' if result['docker_compose'] else 'No'}")

    print(f"\n📂 Git Repository: {'Yes' if result['git']['detected'] else 'No'}")
    if result["git"]["detected"]:
        print(f"   SSH Remotes: {'Yes' if result['git']['ssh_remote'] else 'No'}")
        print(f"   HTTPS Remotes: {'Yes' if result['git']['https_remote'] else 'No'}")

    if result["sensitive_files"]:
        print(f"\n🔒 Sensitive Files Detected:")
        for sf in result["sensitive_files"]:
            print(f"   - {sf}")

    if result["domains_needed"]:
        print(f"\n🌐 Domains Needed:")
        for domain in result["domains_needed"]:
            print(f"   - {domain}")

    if result["excluded_commands"]:
        print(f"\n⚠️  Commands to Exclude from Sandbox:")
        for cmd in result["excluded_commands"]:
            print(f"   - {cmd}")

    if result["recommendations"]:
        print(f"\n💡 Recommendations:")
        for rec in result["recommendations"]:
            print(f"   - {rec['setting']}: {rec['value']}")
            print(f"     Reason: {rec['reason']}")

    print("\n" + "=" * 60)
    print("JSON OUTPUT (for programmatic use):")
    print("=" * 60)
    print(json.dumps(result, indent=2))

    return result


if __name__ == "__main__":
    main()
