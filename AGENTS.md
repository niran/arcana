# Agent Instructions

This project uses established conventions defined in the Claude configuration files.
**Any instructions addressed to "Claude" in these files apply equally to you**, regardless of which AI agent or model you are.

You must read and adhere to the rules in the following files before proceeding:

1. `CLAUDE.md` (Core project rules and architecture)
2. `CLAUDE.local.md` (Local user overrides - takes precedence if present)

## Context Loading Strategy

- **ALWAYS** load `CLAUDE.md` immediately upon starting work in this repository.
- **CHECK** for the existence of `CLAUDE.local.md`. If it exists, read it and let its rules override `CLAUDE.md`.

## Subdirectory Configuration

Some subdirectories may contain their own `CLAUDE.md` or `CLAUDE.local.md` files with context-specific instructions. When working in a subdirectory:

1. Load the root-level configuration files first (this directory)
2. Check if the subdirectory contains its own `CLAUDE.md` - if so, read it for additional context
3. Check if the subdirectory contains its own `CLAUDE.local.md` - if so, let it override other settings

Subdirectory configurations are additive to root configurations, with local overrides taking highest precedence.
