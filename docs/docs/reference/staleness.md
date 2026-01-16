---
sidebar_position: 2
---

# Staleness Tracking

Documentation becomes outdated as codebases evolve. This page tracks when each repository was last evaluated against the documentation.

## Tracking Table

| Repository | Last Evaluated | Evaluator | Notes |
|------------|----------------|-----------|-------|
| *repo-name* | *YYYY-MM-DD* | *Name* | *Any notes about findings* |

## How to Update

After evaluating a repository or updating documentation based on code review:

1. Update the table above with:
   - Today's date
   - Your name
   - Brief notes about any significant changes or confirmations
2. If documentation needed updates, note what was changed

## Evaluation Checklist

When evaluating a repository against documentation:

- [ ] Architecture docs still accurately describe the system
- [ ] Runbook procedures work as documented
- [ ] Configuration values are current (or marked as potentially stale)
- [ ] Links to external resources are still valid
- [ ] Code examples compile/run correctly

## Staleness Thresholds

| Age | Status | Action |
|-----|--------|--------|
| < 30 days | Fresh | Documentation is likely accurate |
| 30-90 days | Aging | Consider verifying before relying on |
| > 90 days | Stale | Verify against code before using |
