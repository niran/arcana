---
name: recent-activity
description: Show recent commits across all team repositories. Use to see what you or teammates have been working on.
---

# Recent Activity Skill

Shows recent commits across all repositories in your knowledge base. Useful for catching up on what's been happening, seeing your own recent work, or understanding what a teammate has been focused on.

## Usage

When this skill is invoked, run the helper script to fetch recent commits:

```bash
.claude/skills/recent-activity/scripts/recent-commits.sh [--author "<name-or-email>"] [--limit <n>]
```

### Options

- `--author` - Filter to commits by a specific person (partial match on name or email, case-insensitive)
- `--limit` - Number of commits per repo (default: 10)

### Examples

**See all recent activity:**
```bash
.claude/skills/recent-activity/scripts/recent-commits.sh
```

**See a specific person's commits:**
```bash
.claude/skills/recent-activity/scripts/recent-commits.sh --author "niran"
```

**See the current user's commits:**
First get their email with `git config user.email`, then:
```bash
.claude/skills/recent-activity/scripts/recent-commits.sh --author "<user email>"
```

## Output Format

The script outputs commits grouped by repository with dates:

```
## owner/repo-name
2026-01-15 Author Name: commit message
2026-01-14 Author Name: another commit message

## owner/another-repo
2026-01-15 Author Name: commit message
```

## How It Works

1. Reads `.gitmodules` to find all team repositories
2. Extracts the GitHub host and owner/repo from each URL
3. Queries the GitHub API for recent commits (supports both github.com and GitHub Enterprise)
4. Filters by author if specified
5. Skips repos that fail (private, no access) and continues with the rest

## Requirements

- `gh` CLI authenticated with access to the repositories
- `.gitmodules` file in the repository (or a parent directory)
