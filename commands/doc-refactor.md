---
description: Restructure project documentation for clarity and accessibility
---

# Documentation Refactor

Refactor project documentation structure adapted to project type.

## Workflow

### 1. Analyze Project

Identify:
- Type (library/API/web app/CLI/microservices)
- Architecture
- User personas

### 2. Centralize Docs

Move technical documentation to `docs/` with proper cross-references.

### 3. Root README.md

Streamline as entry point:
- Overview
- Quickstart
- Modules/components summary
- License
- Contacts

### 4. Component Docs

Add module/package/service-level README files with:
- Setup instructions
- Testing instructions

### 5. Organize `docs/`

By relevant categories (adapt to project needs):
- Architecture
- API Reference
- Database
- Design
- Troubleshooting
- Deployment
- Contributing

### 6. Create Guides

Select applicable:
- **User Guide**: End-user documentation for applications
- **API Documentation**: Endpoints, authentication, examples for APIs
- **Development Guide**: Setup, testing, contribution workflow
- **Deployment Guide**: Production deployment for services/apps

### 7. Use Mermaid

For all diagrams:
- Architecture
- Flows
- Schemas

## Guidelines

- Keep docs concise, scannable, and contextual to project type
