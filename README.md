# [Project Name] Arcana

Operational knowledge base for [Project Name]. Ask questions, get answers as good as your coworkers.

## Quick Start

```bash
git clone <repo-url>
cd arcana
claude
```

The primary interface is **Claude Code**. Clone the repo and start asking questions. Claude reads the knowledge base, searches your local code, and answers questions about operations, architecture, and past incidents.

### Example Questions

- "How does [component] work?"
- "What caused the [date] incident?"
- "How do I deploy [service]?"
- "What's the difference between [A] and [B]?"

## Skills

This repo can include interactive skills for common operational tasks. Add skills to `.claude/skills/` and invoke them with slash commands.

| Skill | Command | Description |
|-------|---------|-------------|
| *Add skills as needed* | `/skill-name` | Description |

## Browsing the Docs

The knowledge base is also designed for human readers. Run the docs locally:

```bash
cd docs
npm install
npm start
```

Opens at http://localhost:3000

### What's Here

```
docs/               # Docusaurus knowledge base
├── architecture/   # System design, component relationships
├── runbooks/       # Step-by-step operational procedures
├── reference/      # Configuration, documentation sources
├── specs/          # Protocol or API specifications
└── blog/           # Incidents, insights, decisions

repos/              # Submodules (not checked out by default)
```

The submodules document which repos exist. Claude searches your local workspace for the actual code.

## Local Setup

Create `CLAUDE.local.md` to tell Claude where your repos live:

```markdown
## My Workspace

- repo-name: ~/code/repo-name
- another-repo: ~/work/another-repo
```

Without this, Claude searches `~/workspace` and common locations automatically.

## Contributing

**Update docs when you notice they're wrong.** Code is the source of truth. If docs don't match, fix the docs.

**Add incidents after resolving them.** Create a blog post in `docs/blog/` with the `incident` tag. See existing incidents for format.

**Share insights.** If you learn something useful about operations, add it to the appropriate runbook or architecture doc.
