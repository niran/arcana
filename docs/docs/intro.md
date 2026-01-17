---
sidebar_position: 1
slug: /
---

# Welcome to [Project Name] Arcana

This is the operational knowledge base for [Project Name]. It's designed to be used with **Claude Code** as an AI-powered assistant that can answer questions about your system as well as (or better than) your coworkers.

## Getting Started

1. Clone this repo and run `claude` in the root directory
2. Ask questions about architecture, operations, or past incidents
3. Claude searches the knowledge base and your local code to find answers

## What's Here

### [Architecture](./architecture/overview)

System design documentation covering components, data flows, and infrastructure.

### [Runbooks](./runbooks/overview)

Step-by-step operational procedures for common tasks and incident response.

### [Specs](./specs/overview)

Protocol and API specifications.

### [Reference](./reference/repos)

Configuration reference and documentation sources.

### [Blog](/blog)

Incident reports, contributor insights, and decision rationale.

### Skills

Interactive commands for common tasks:
- `/recent-activity` - See recent commits across team repositories
- `/writing-coach` - Thinking partner for working through ideas and blocks
- `/import` - Populate the knowledge base with repos and docs
- `/update-knowledge` - Check repos for changes and update documentation

Skills also work with other AI tools. In Codex CLI, Gemini CLI, or similar, reference the skill file directly (e.g., `Use .claude/skills/writing-coach/SKILL.md`).

## Philosophy

**Code is the source of truth.** This documentation supplements code understanding but should never contradict it. When docs are outdated, update them.

**Learn from incidents.** After resolving issues, document what happened in the blog with the `incident` tag.

**Share knowledge.** If you learn something useful, add it here so your coworkers benefit too.
