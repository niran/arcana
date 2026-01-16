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

Interactive skills for common tasks. Invoke with slash commands in Claude Code.

| Skill | Command | Description |
|-------|---------|-------------|
| Import | `/import` | Populate the knowledge base with repos, docs, and operational knowledge |
| Writing Coach | `/writing-coach` | Collaborative thinking partner to work through ideas, overcome blocks, and clarify thinking |
| Recent Activity | `/recent-activity` | See recent commits across all team repositories |

### Writing Coach

Run `/writing-coach` when you need a thinking partner. Claude will:

- Check recent blog posts for team-level topics worth discussing
- Offer to look at your personal recent commits for conversation starters
- Ask questions to help pull ideas out of your head
- Write up the conversation as a document when you're ready

The goal is to make writer's block and unclear thinking nearly impossible. Claude ends every response with a question to keep you moving forward.

### Recent Activity

Run `/recent-activity` to see what's been happening across all team repos. Useful for:

- Catching up after time away
- Seeing what a teammate has been working on (`--author "name"`)
- Finding context for a conversation

### Getting Started with Import

New to this repo? Run `/import` to begin populating your knowledge base:

1. **Add repositories** - Claude detects branches and adds submodules
2. **Synthesize existing docs** - Paste onboarding guides and architecture docs
3. **Analyze codebases** - Claude reads each repo and writes documentation
4. **Add operational knowledge** - Import runbooks, alerts, and incident history
5. **Create custom skills** - Build skills tailored to your workflows

Progress is tracked in the README so you can stop and resume anytime.

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
