# Agent Instructions

This project uses established conventions defined in the Claude configuration files.
**Any instructions addressed to "Claude" in these files apply equally to you**, regardless of which AI agent or model you are.

You must read and adhere to the rules in the following files before proceeding:

1. `CLAUDE.md` (Core project rules and architecture)
2. `CLAUDE.local.md` (Local user overrides - takes precedence if present)

## Context Loading Strategy

- **ALWAYS** load `CLAUDE.md` immediately upon starting work in this repository.
- **CHECK** for the existence of `CLAUDE.local.md`. If it exists, read it and let its rules override `CLAUDE.md`.

## Claude Skills (Use In Any Agent)

This repo includes "Claude skills": reusable, file-based workflows stored as Markdown. They are designed to work in *any* AI tool that can read files (Codex CLI, Gemini CLI, Cursor, etc.).

### Where Skills Live

- Primary location: `.claude/skills/<skill-name>/SKILL.md`
- Skill metadata is usually in YAML frontmatter (`name`, `description`) at the top of `SKILL.md`.
- Skills may include runnable helpers under `.claude/skills/<skill-name>/scripts/`.

### Enumerating Skills (For Non-Native Harnesses)

Some tools intercept `/slash-commands` before they reach the model, so **do not rely on `/skill-name` being visible to the agent**.

To enumerate skills the way a native agent would, use:

- Script: `.claude/scripts/skills-manifest.sh` (or `.claude/scripts/skills-manifest.py`)
- Generated manifests: `.claude/skills/manifest.json` and `.claude/skills/manifest.md`

Harnesses for other agents should load `manifest.json` (or run the script) to discover available skills and expose them as tool-native commands if desired.

### How To Invoke Skills (Cross-Agent Contract)

Use one of these model-visible forms:

- "Use skill: `<skill-name>`" (preferred)
- "Open and follow: `.claude/skills/<skill-name>/SKILL.md`"
- "Use the skill file: `.claude/skills/<skill-name>/SKILL.md`"

### How To Run A Skill

1. Open the relevant `SKILL.md`.
2. Follow the **Instructions** section as written (it is the source of truth).
3. Prefer using any included scripts/templates referenced by the skill instead of re-creating them.
4. Load only the additional files the skill points to; avoid bulk-loading the repo.

If the user asks for a skill name that doesn't exist, consult `.claude/skills/manifest.json` (or regenerate it) and ask the user to confirm the closest match.

## Subdirectory Configuration

Some subdirectories may contain their own `CLAUDE.md` or `CLAUDE.local.md` files with context-specific instructions. When working in a subdirectory:

1. Load the root-level configuration files first (this directory)
2. Check if the subdirectory contains its own `CLAUDE.md` - if so, read it for additional context
3. Check if the subdirectory contains its own `CLAUDE.local.md` - if so, let it override other settings

Subdirectory configurations are additive to root configurations, with local overrides taking highest precedence.
