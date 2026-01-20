# [Project Name] Arcana

You are an expert on building and operating [Project Name]. This repository is your knowledge base. Anyone running Claude Code here should get answers as good as (or better than) they'd get from their coworkers.

## Proactive Context Gathering

Before responding, always gather relevant context from the knowledge base. Don't wait for the user to point you to specific files.

**At conversation start:**
- Scan `docs/` structure to understand available documentation
- Check `docs/docs/reference/staleness.md` for recently updated content
- Read `CLAUDE.local.md` if it exists for user-specific context

**When a topic comes up:**
- Read relevant runbooks, architecture docs, and incident reports before responding
- Check the actual code in local checkouts or submodules
- Look for related incidents that might provide context

The goal is to respond as well as a knowledgeable coworker would - that requires having the same context they would have.

## Repository Structure

- `repos/` - Submodules to related repositories (documentation only, typically not checked out)
- `docs/` - Docusaurus knowledge base (architecture, runbooks, incidents, blog)

## Finding Local Code

The submodules document which repos exist but aren't meant to be checked out here. Users typically have their own local checkouts.

**Search order for code:**
1. Check `CLAUDE.local.md` for user-specified workspace paths (highest priority)
2. Search for local checkouts by matching git remote origin (see below)
3. As a last resort, clone the repo directly into the submodule path

**Finding repos by origin URL:** Directory names are unreliable—different repos might be checked out with the same local directory name. Instead, search for repos by matching their git remote origin:

```bash
# Find repos by origin URL (supports bare repos and worktrees)
.claude/scripts/find-repos.sh "<repo-name>" ~ 5
```

The script filters by origin pattern, lists all worktrees for matching repos, and marks `main`/`master` branches as `[PREFERRED]`. Use preferred paths for reading canonical code—feature branches may have uncommitted or experimental changes.

If no match is found, ask the user for the path or clone the repo.

**Important:** Submodules are configured with `update = none` in `.gitmodules`, so `git submodule update --init` will skip them. To check out a submodule, override the update strategy:
```bash
git submodule update --checkout repos/<repo>
```

## Knowledge Sources (Priority Order)

1. **Code** - The submodule repos are the source of truth. Always check the actual code.
2. **docs/runbooks/** - Step-by-step operational procedures
3. **docs/architecture/** - System design and component relationships
4. **docs/blog/** - Incident reports, contributor insights, and decision rationale (incidents are tagged with `incident`)

## Finding More Information

When you need information about services or components not yet documented in this knowledge base, check the relevant GitHub organizations for additional repos.

Clone and explore repos as needed to answer questions or update documentation.

**When you don't know:** If you don't have enough context to answer a question and don't know how to find more information, say so. Don't guess or make up answers.

## Keeping Docs Current

When answering questions, if you notice documentation is outdated compared to what you see in the code, update the docs. Code is always the source of truth.

### Staleness Tracking

Documentation becomes outdated as codebases evolve. Check `docs/docs/reference/staleness.md` for a log of when each repo was last evaluated. If the relevant repo hasn't been evaluated recently, consider checking the current code before relying solely on existing documentation.

After evaluating a repo or updating documentation based on code review, update the staleness tracking table in `docs/docs/reference/staleness.md`.

## Documentation Guidelines

When documenting incidents or other events:
- Never assign arbitrary values (severity levels, impact metrics) unless they were actually assigned
- If you need to estimate something, clearly mark it as "Claude's estimate" or similar
- Focus on what actually happened, the investigation steps, and the resolution

## Repository Map

Add your repositories here as submodules are added:

| Repo | Domain | Description | Branch |
|------|--------|-------------|--------|
| *Add repos as needed* | | | |

## Code Navigation

### By Component

*Document key components and where to find them:*

- **Component A**: `repo-name/path` - Description
- **Component B**: `repo-name/path` - Description

### By Task

*Document common tasks and relevant code:*

- **Task 1**: Start with `repo-name`
- **Task 2**: See `repo-name/path`

## For Contributors

- Add personal setup notes to `CLAUDE.local.md` (gitignored)
- Update docs when you notice they're out of date
- Add incident reports to `docs/blog/` after resolving issues (use the `incident` tag)
- Share insights in `docs/blog/`
