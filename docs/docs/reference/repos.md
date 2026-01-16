---
sidebar_position: 1
---

# Repository Map

This page documents the repositories relevant to [Project Name].

## Repositories

| Repo | Domain | Description | Branch |
|------|--------|-------------|--------|
| *repo-name* | *Domain* | *Description* | *main* |

## Adding Repositories

To add a repository as a submodule:

```bash
# Add as a submodule (replace with your repo URL and path)
git submodule add -b main https://github.com/org/repo repos/repo

# Configure to not auto-checkout (we use submodules as documentation)
git config -f .gitmodules submodule.repos/repo.update none
```

Then update this page with the new repository information.

## Repository Domains

Organize repositories by domain:

| Domain | Description |
|--------|-------------|
| Core | Primary system components |
| Infrastructure | Deployment and infrastructure |
| Tooling | Development and operational tools |
| Documentation | Documentation repositories |
