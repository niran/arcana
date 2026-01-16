---
name: update-knowledge
description: Update your knowledge base using changes in repos since the last evaluation. Checks what changed, helps update documentation, and records the new evaluation in the staleness log.
---

# Update Knowledge Skill

This skill helps keep your knowledge base current by identifying what changed in repositories since they were last evaluated, then guiding you through updating relevant documentation.

## Overview

The knowledge base tracks when each repo was last evaluated in `docs/docs/reference/staleness.md`. This skill:

1. Shows what repos have changes since their last evaluation
2. Helps you review the changes and update documentation
3. Updates the staleness log with the new evaluation date and revision

## Instructions

When this skill is invoked:

### Step 1: Read the Staleness Log

Read `docs/docs/reference/staleness.md` to understand:
- Which repos are tracked
- When each was last evaluated
- What revision was last checked

Parse the evaluation log table to extract:
- Repo name
- Last evaluated date
- Previous revision SHA
- Related docs that were updated

### Step 2: Fetch Changes for All Repos

Before presenting options, fetch commits since the last evaluation for each tracked repo. This lets you show the user which repos actually have changes.

For each repo in the staleness log:
1. Find its URL in `.gitmodules`
2. Fetch commits since the last recorded revision

Use the helper script:
```bash
.claude/skills/update-knowledge/scripts/repo-changes.sh "<repo-url>" --since-rev "<last-revision>" --limit 30
```

Or if no revision was recorded, use the date:
```bash
.claude/skills/update-knowledge/scripts/repo-changes.sh "<repo-url>" --since-date "<last-evaluated-date>"
```

**Finding repo URLs:**
- Parse `.gitmodules` to find the URL for each repo
- The repo name in staleness.md may differ from the submodule path
- Match by repo name against submodule paths

### Step 3: Present Repos with Changes

Show the user which repos have new commits since their last evaluation:

```
I checked all tracked repositories for changes since their last evaluation.

**Repos with new commits:**

| Repo | Last Evaluated | New Commits | Latest Commit |
|------|----------------|-------------|---------------|
| repo-a | 2026-01-15 | 12 | 2026-01-16 |
| repo-b | 2026-01-15 | 3 | 2026-01-16 |
...

**Repos with no changes:** <list of repos with no new commits>

Which repos would you like to review?

1. Review all repos with changes (Recommended)
2. Review specific repos
3. Skip - just update staleness log for repos with no doc-relevant changes
```

Use AskUserQuestion to let the user choose.

### Step 4: Present Changes for Each Repo

For each repo the user wants to review, show:

```
## <repo-name>

**Changes since <last-eval-date> (<N> commits):**

<commit list from script>

**Related docs:** <docs-updated from staleness log>

Would you like to:
1. Review this repo's changes and update docs
2. Skip this repo
3. Mark as evaluated with no doc changes needed
```

### Step 5: Guide Documentation Updates

When the user chooses to review a repo:

1. **Access the latest code:**
   - Use the GitHub API to read files directly (avoids local checkout issues)
   - Or check out the submodule: `git submodule update --checkout <path>`
   - Avoid user's local checkouts - they may be on feature branches or have uncommitted changes

2. **Analyze significant changes:**
   - Focus on commits that change behavior, APIs, or architecture
   - Skip routine maintenance, version bumps, and minor fixes
   - Look for new features, breaking changes, and bug fixes

3. **Identify docs to update:**
   - Check which docs were previously updated for this repo
   - Read those docs and compare to current code
   - Look for new components or patterns that need documentation

4. **Make updates:**
   - Update relevant architecture docs, runbooks, or reference docs
   - Add new docs if the repo has significant new functionality
   - Ensure docs reflect the current state of the code

5. **After updating, ask:**
   ```
   I've updated:
   - <list of docs updated>

   Would you like me to:
   1. Commit these changes
   2. Review the changes first
   3. Continue to the next repo
   ```

### Step 6: Update Staleness Log

After completing a repo evaluation (whether docs were updated or not):

1. Get the current HEAD SHA for the repo (shown in script output)
2. Update the staleness.md table entry:
   - `Last Evaluated`: today's date
   - `Revision`: current HEAD SHA
   - `Revision Date`: date of latest commit
   - `Docs Updated`: list docs that were updated (or "-" if none)
   - `Notes`: brief summary of changes or "No significant changes"

Example update:
```markdown
| repo-name | 2026-01-16 | architecture/repo-name.md | a1b2c3d... | 2026-01-15 | Added new health check modes |
```

### Step 7: Continue or Finish

After each repo, ask:
```
<repo-name> evaluation complete.

Remaining repos to check: <list>

Would you like to:
1. Continue to the next repo (<next-repo-name>)
2. Check a different repo
3. Finish for now
```

## Helper Scripts

### repo-changes.sh

Fetches commits from a repo since a specific revision or date:

```bash
.claude/skills/update-knowledge/scripts/repo-changes.sh <repo-url> [options]

Options:
  --since-rev <sha>        Show commits after this revision
  --since-date <YYYY-MM-DD> Show commits after this date
  --limit <n>              Max commits to fetch (default: 20)
```

Output includes commit list and current HEAD SHA.

### parse-staleness.sh

Parses the staleness log to extract evaluation info:

```bash
.claude/skills/update-knowledge/scripts/parse-staleness.sh [options]

Options:
  --repo <name>      Filter to specific repo
  --stale-days <n>   Only show repos not evaluated in N days
```

Output is TSV: `repo_name<TAB>last_evaluated<TAB>docs_updated<TAB>revision<TAB>revision_date<TAB>notes`

## Mapping Repos to URLs

The staleness log uses repo names that may differ from submodule paths. Use `.gitmodules` to find the actual URL for each repo. Match by the repository name portion of the path.

## Best Practices

1. **Focus on significant changes.** Not every commit needs documentation updates. Focus on:
   - New features or components
   - API changes
   - Configuration changes
   - Behavioral changes

2. **Update, don't append.** Documentation should reflect the current state. Replace outdated information rather than adding caveats.

3. **Cross-reference.** When updating one doc, check if related docs also need updates.

4. **Commit atomically.** Commit doc updates for each repo separately with clear messages.

5. **Note what didn't change.** When a repo has commits but no doc updates needed, note this in the staleness log to explain why.
