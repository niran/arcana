---
sidebar_position: 1
---

# Architecture Overview

This section documents the system architecture of [Project Name].

## Components

| Component | Purpose | Repository |
|-----------|---------|------------|
| *Component A* | *Description* | *repo-name* |
| *Component B* | *Description* | *repo-name* |

## System Diagram

```
┌─────────────────────────────────────────────────────┐
│                    [Project Name]                    │
├─────────────────────────────────────────────────────┤
│                                                      │
│   ┌──────────┐    ┌──────────┐    ┌──────────┐     │
│   │Component │───▶│Component │───▶│Component │     │
│   │    A     │    │    B     │    │    C     │     │
│   └──────────┘    └──────────┘    └──────────┘     │
│                                                      │
└─────────────────────────────────────────────────────┘
```

## Key Concepts

### Concept 1

*Describe a key concept...*

### Concept 2

*Describe another key concept...*

## Data Flows

*Document how data moves through the system...*

## Adding Architecture Docs

When adding new architecture documentation:

1. Create a new `.md` file in this directory
2. Add a `sidebar_position` frontmatter to control ordering
3. Include diagrams where helpful (ASCII or Mermaid)
4. Link to relevant runbooks and specs
5. Keep focused on "what" and "why" - leave "how to operate" for runbooks
