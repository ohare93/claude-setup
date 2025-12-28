# Stack-Specific Configuration Templates

Pre-built Claude Code Sandbox configurations for common technology stacks. These serve as starting points and should be customized based on project-specific needs.

---

## Node.js / JavaScript / TypeScript

### Base Template
```json
{
    "sandbox": {
        "enabled": true,
        "autoAllowBashIfSandboxed": true,
        "allowUnsandboxedCommands": true,
        "excludedCommands": [],
        "network": {
            "allowLocalBinding": true
        }
    },
    "permissions": {
        "allow": [
            "Bash(npm:*)",
            "Bash(npx:*)",
            "Bash(yarn:*)",
            "Bash(pnpm:*)",
            "Bash(node:*)",
            "Bash(tsc:*)",
            "WebFetch(domain:registry.npmjs.org)",
            "WebFetch(domain:registry.yarnpkg.com)"
        ],
        "deny": [
            "Read(./.env)",
            "Read(./.env.*)"
        ],
        "ask": [
            "Bash(npm publish:*)"
        ]
    }
}
```

### Next.js Project
```json
{
    "sandbox": {
        "enabled": true,
        "autoAllowBashIfSandboxed": true,
        "allowUnsandboxedCommands": true,
        "excludedCommands": [],
        "network": {
            "allowLocalBinding": true
        }
    },
    "permissions": {
        "allow": [
            "Bash(npm:*)",
            "Bash(npx:*)",
            "Bash(next:*)",
            "Bash(node:*)",
            "WebFetch(domain:registry.npmjs.org)",
            "WebFetch(domain:vercel.com)",
            "WebFetch(domain:api.vercel.com)"
        ],
        "deny": [
            "Read(./.env)",
            "Read(./.env.local)",
            "Read(./.env.production)"
        ],
        "ask": [
            "Bash(npm publish:*)",
            "Bash(vercel:*)"
        ]
    }
}
```

### Testing (Jest/Vitest)
Add to base template:
```json
{
    "permissions": {
        "allow": [
            "Bash(jest:*)",
            "Bash(vitest:*)",
            "Bash(npm test:*)",
            "Bash(npm run test:*)"
        ]
    }
}
```

**Note**: For Jest watch mode, use `--no-watchman` flag.

---

## Python

### Base Template
```json
{
    "sandbox": {
        "enabled": true,
        "autoAllowBashIfSandboxed": true,
        "allowUnsandboxedCommands": true,
        "excludedCommands": [],
        "network": {
            "allowLocalBinding": true
        }
    },
    "permissions": {
        "allow": [
            "Bash(python:*)",
            "Bash(python3:*)",
            "Bash(pip:*)",
            "Bash(pip3:*)",
            "Bash(pytest:*)",
            "Bash(ruff:*)",
            "Bash(black:*)",
            "Bash(mypy:*)",
            "WebFetch(domain:pypi.org)",
            "WebFetch(domain:files.pythonhosted.org)"
        ],
        "deny": [
            "Read(./.env)",
            "Read(./.env.*)",
            "Read(./secrets/**)",
            "Read(./**/credentials.py)"
        ],
        "ask": [
            "Bash(pip install --user:*)"
        ]
    }
}
```

### Django Project
```json
{
    "sandbox": {
        "enabled": true,
        "autoAllowBashIfSandboxed": true,
        "allowUnsandboxedCommands": true,
        "excludedCommands": [],
        "network": {
            "allowLocalBinding": true
        }
    },
    "permissions": {
        "allow": [
            "Bash(python:*)",
            "Bash(python3:*)",
            "Bash(pip:*)",
            "Bash(pytest:*)",
            "Bash(./manage.py:*)",
            "Bash(django-admin:*)",
            "WebFetch(domain:pypi.org)",
            "WebFetch(domain:files.pythonhosted.org)"
        ],
        "deny": [
            "Read(./.env)",
            "Read(./.env.*)",
            "Read(./settings/production.py)",
            "Read(./**/secrets.py)"
        ]
    }
}
```

### FastAPI Project
```json
{
    "sandbox": {
        "enabled": true,
        "autoAllowBashIfSandboxed": true,
        "allowUnsandboxedCommands": true,
        "excludedCommands": [],
        "network": {
            "allowLocalBinding": true
        }
    },
    "permissions": {
        "allow": [
            "Bash(python:*)",
            "Bash(uvicorn:*)",
            "Bash(pip:*)",
            "Bash(pytest:*)",
            "WebFetch(domain:pypi.org)",
            "WebFetch(domain:files.pythonhosted.org)"
        ],
        "deny": [
            "Read(./.env)",
            "Read(./.env.*)"
        ]
    }
}
```

### Poetry/UV Projects
Add to base template:
```json
{
    "permissions": {
        "allow": [
            "Bash(poetry:*)",
            "Bash(uv:*)"
        ]
    }
}
```

---

## Rust

### Base Template
```json
{
    "sandbox": {
        "enabled": true,
        "autoAllowBashIfSandboxed": true,
        "allowUnsandboxedCommands": true,
        "excludedCommands": [],
        "network": {
            "allowLocalBinding": true
        }
    },
    "permissions": {
        "allow": [
            "Bash(cargo:*)",
            "Bash(rustc:*)",
            "Bash(rustup:*)",
            "Bash(clippy:*)",
            "WebFetch(domain:crates.io)",
            "WebFetch(domain:static.crates.io)",
            "WebFetch(domain:index.crates.io)"
        ],
        "deny": [
            "Read(./.env)",
            "Read(./secrets/**)"
        ],
        "ask": [
            "Bash(cargo publish:*)"
        ]
    }
}
```

---

## Go

### Base Template
```json
{
    "sandbox": {
        "enabled": true,
        "autoAllowBashIfSandboxed": true,
        "allowUnsandboxedCommands": true,
        "excludedCommands": [],
        "network": {
            "allowLocalBinding": true
        }
    },
    "permissions": {
        "allow": [
            "Bash(go:*)",
            "Bash(gofmt:*)",
            "Bash(golint:*)",
            "Bash(staticcheck:*)",
            "WebFetch(domain:proxy.golang.org)",
            "WebFetch(domain:sum.golang.org)",
            "WebFetch(domain:github.com)"
        ],
        "deny": [
            "Read(./.env)",
            "Read(./secrets/**)"
        ]
    }
}
```

---

## PHP / WordPress

### PHP (Composer)
```json
{
    "sandbox": {
        "enabled": true,
        "autoAllowBashIfSandboxed": true,
        "allowUnsandboxedCommands": true,
        "excludedCommands": [],
        "network": {
            "allowLocalBinding": true
        }
    },
    "permissions": {
        "allow": [
            "Bash(php:*)",
            "Bash(composer:*)",
            "Bash(phpunit:*)",
            "Bash(phpstan:*)",
            "WebFetch(domain:packagist.org)",
            "WebFetch(domain:repo.packagist.org)"
        ],
        "deny": [
            "Read(./.env)",
            "Read(./config/production.php)"
        ]
    }
}
```

### WordPress Development
```json
{
    "sandbox": {
        "enabled": true,
        "autoAllowBashIfSandboxed": true,
        "allowUnsandboxedCommands": true,
        "excludedCommands": ["docker", "docker-compose", "wp-env"],
        "network": {
            "allowLocalBinding": true
        }
    },
    "permissions": {
        "allow": [
            "Bash(php:*)",
            "Bash(composer:*)",
            "Bash(wp:*)",
            "Bash(phpunit:*)",
            "WebFetch(domain:packagist.org)",
            "WebFetch(domain:repo.packagist.org)",
            "WebFetch(domain:wordpress.org)",
            "WebFetch(domain:api.wordpress.org)"
        ],
        "deny": [
            "Read(./.env)",
            "Read(./wp-config.php)",
            "Read(./wp-config-local.php)"
        ]
    }
}
```

---

## Ruby / Rails

### Base Template
```json
{
    "sandbox": {
        "enabled": true,
        "autoAllowBashIfSandboxed": true,
        "allowUnsandboxedCommands": true,
        "excludedCommands": [],
        "network": {
            "allowLocalBinding": true
        }
    },
    "permissions": {
        "allow": [
            "Bash(ruby:*)",
            "Bash(bundle:*)",
            "Bash(rails:*)",
            "Bash(rake:*)",
            "Bash(rspec:*)",
            "WebFetch(domain:rubygems.org)",
            "WebFetch(domain:api.rubygems.org)"
        ],
        "deny": [
            "Read(./.env)",
            "Read(./config/credentials.yml.enc)",
            "Read(./config/master.key)"
        ]
    }
}
```

---

## Java / Kotlin

### Maven
```json
{
    "sandbox": {
        "enabled": true,
        "autoAllowBashIfSandboxed": true,
        "allowUnsandboxedCommands": true,
        "excludedCommands": [],
        "network": {
            "allowLocalBinding": true
        }
    },
    "permissions": {
        "allow": [
            "Bash(mvn:*)",
            "Bash(java:*)",
            "Bash(javac:*)",
            "WebFetch(domain:repo.maven.apache.org)",
            "WebFetch(domain:repo1.maven.org)"
        ],
        "deny": [
            "Read(./.env)",
            "Read(./src/main/resources/application-prod.properties)"
        ]
    }
}
```

### Gradle
```json
{
    "sandbox": {
        "enabled": true,
        "autoAllowBashIfSandboxed": true,
        "allowUnsandboxedCommands": true,
        "excludedCommands": [],
        "network": {
            "allowLocalBinding": true
        }
    },
    "permissions": {
        "allow": [
            "Bash(gradle:*)",
            "Bash(./gradlew:*)",
            "Bash(java:*)",
            "WebFetch(domain:repo.maven.apache.org)",
            "WebFetch(domain:plugins.gradle.org)",
            "WebFetch(domain:services.gradle.org)"
        ],
        "deny": [
            "Read(./.env)"
        ]
    }
}
```

---

## .NET / C#

### Base Template
```json
{
    "sandbox": {
        "enabled": true,
        "autoAllowBashIfSandboxed": true,
        "allowUnsandboxedCommands": true,
        "excludedCommands": [],
        "network": {
            "allowLocalBinding": true
        }
    },
    "permissions": {
        "allow": [
            "Bash(dotnet:*)",
            "WebFetch(domain:api.nuget.org)",
            "WebFetch(domain:nuget.org)"
        ],
        "deny": [
            "Read(./.env)",
            "Read(./appsettings.Production.json)"
        ]
    }
}
```

---

## Monorepo / Multi-Stack

### General Template
```json
{
    "sandbox": {
        "enabled": true,
        "autoAllowBashIfSandboxed": true,
        "allowUnsandboxedCommands": true,
        "excludedCommands": ["docker", "docker-compose"],
        "network": {
            "allowLocalBinding": true
        }
    },
    "permissions": {
        "additionalDirectories": [
            "../shared",
            "../../tools"
        ],
        "allow": [
            "Bash(npm:*)",
            "Bash(yarn:*)",
            "Bash(pnpm:*)",
            "Bash(turbo:*)",
            "Bash(nx:*)",
            "Bash(lerna:*)",
            "WebFetch(domain:registry.npmjs.org)"
        ],
        "deny": [
            "Read(./.env)",
            "Read(./.env.*)",
            "Read(./**/secrets/**)"
        ]
    }
}
```

---

## Security Posture Templates

### Learning/Exploration (Minimal Friction)
```json
{
    "sandbox": {
        "enabled": true,
        "autoAllowBashIfSandboxed": true,
        "allowUnsandboxedCommands": true,
        "network": {
            "allowLocalBinding": true
        }
    },
    "permissions": {
        "deny": [
            "Read(./.env)",
            "Read(./.env.*)"
        ]
    }
}
```

### High Security (Fail-Closed)
```json
{
    "sandbox": {
        "enabled": true,
        "autoAllowBashIfSandboxed": false,
        "allowUnsandboxedCommands": false,
        "excludedCommands": [],
        "network": {
            "allowLocalBinding": false,
            "allowUnixSockets": []
        }
    },
    "permissions": {
        "allow": [],
        "deny": [
            "Read(./.env)",
            "Read(./.env.*)",
            "Read(./secrets/**)",
            "Bash(curl:*)",
            "Bash(wget:*)",
            "Bash(nc:*)",
            "Bash(netcat:*)"
        ],
        "ask": [
            "Bash",
            "Edit",
            "WebFetch"
        ]
    }
}
```

### CI/CD Pipeline
```json
{
    "sandbox": {
        "enabled": true,
        "autoAllowBashIfSandboxed": true,
        "allowUnsandboxedCommands": false,
        "excludedCommands": [],
        "enableWeakerNestedSandbox": true
    },
    "permissions": {
        "allow": [
            "Bash(npm ci)",
            "Bash(npm run build)",
            "Bash(npm test)",
            "Bash(pip install -r requirements.txt)",
            "Bash(pytest:*)"
        ],
        "deny": [
            "Bash(npm publish:*)",
            "Bash(git push:*)",
            "Read(./.env.production)"
        ]
    }
}
```

---

## Add-On Configurations

### Docker/Containers
Add to `excludedCommands`:
```json
{
    "sandbox": {
        "excludedCommands": ["docker", "docker-compose", "podman", "docker-compose-plugin"]
    }
}
```

### Kubernetes
Add to `excludedCommands` and permissions:
```json
{
    "sandbox": {
        "excludedCommands": ["kubectl", "helm", "k9s", "minikube"]
    },
    "permissions": {
        "deny": [
            "Read(./kubeconfig)",
            "Read(./**/kubeconfig)"
        ]
    }
}
```

### SSH Git Authentication
Add to network settings:
```json
{
    "sandbox": {
        "network": {
            "allowUnixSockets": [
                "/run/user/1000/ssh-agent.socket"
            ]
        }
    }
}
```
Find your socket: `echo $SSH_AUTH_SOCK`

### Database CLIs
Add to `excludedCommands` if needed:
```json
{
    "sandbox": {
        "excludedCommands": ["psql", "mysql", "mongosh", "redis-cli"]
    }
}
```

### Cloud CLIs
Add to permissions (use with caution):
```json
{
    "permissions": {
        "ask": [
            "Bash(aws:*)",
            "Bash(gcloud:*)",
            "Bash(az:*)"
        ],
        "deny": [
            "Read(~/.aws/credentials)",
            "Read(~/.config/gcloud/**)"
        ]
    }
}
```
