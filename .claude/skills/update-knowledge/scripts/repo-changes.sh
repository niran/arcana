#!/bin/bash
#
# Show commits in a repo since a specific revision or date
#
# Usage: repo-changes.sh <repo-url> [--since-rev <sha>] [--since-date <YYYY-MM-DD>] [--limit <n>]
#
# If --since-rev is provided, shows commits after that revision
# If --since-date is provided, shows commits after that date
# If neither, shows last --limit commits (default 20)
#
# Requires: gh (GitHub CLI) authenticated
# Supports: github.com and GitHub Enterprise instances
#

set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Usage: repo-changes.sh <repo-url> [--since-rev <sha>] [--since-date <YYYY-MM-DD>] [--limit <n>]" >&2
    exit 1
fi

REPO_URL="$1"
shift

SINCE_REV=""
SINCE_DATE=""
LIMIT=20

while [[ $# -gt 0 ]]; do
    case $1 in
        --since-rev)
            SINCE_REV="$2"
            shift 2
            ;;
        --since-date)
            SINCE_DATE="$2"
            shift 2
            ;;
        --limit)
            LIMIT="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
    esac
done

# Extract host from git URL
url_to_host() {
    local url="$1"
    local host

    # Handle HTTPS URLs: https://hostname/owner/repo.git
    if [[ "$url" =~ ^https?:// ]]; then
        host=$(echo "$url" | sed -E 's|^https?://([^/]+)/.*|\1|')
    # Handle SSH URLs: git@hostname:owner/repo.git
    elif [[ "$url" =~ ^git@ ]]; then
        host=$(echo "$url" | sed -E 's|^git@([^:]+):.*|\1|')
    else
        echo ""
        return
    fi

    # Return empty for github.com (gh uses it by default)
    if [[ "$host" == "github.com" ]]; then
        echo ""
    else
        echo "$host"
    fi
}

# Convert git URL to owner/repo format
url_to_repo() {
    local url="$1"
    echo "$url" | sed -E 's|^https?://[^/]+/||; s|^git@[^:]+:||; s|\.git$||'
}

REPO=$(url_to_repo "$REPO_URL")
HOST=$(url_to_host "$REPO_URL")

if [[ -z "$REPO" ]]; then
    echo "Could not parse repo from URL: $REPO_URL" >&2
    exit 1
fi

# Build API query parameters
QUERY="per_page=${LIMIT}"
if [[ -n "$SINCE_DATE" ]]; then
    QUERY="${QUERY}&since=${SINCE_DATE}T00:00:00Z"
fi

# Fetch commits
fetch_commits() {
    local jq_filter='.[] | "\(.sha[0:8]) \(.commit.author.date | split("T")[0]) \(.commit.author.name): \(.commit.message | split("\n")[0])"'

    if [[ -n "$HOST" ]]; then
        gh api "repos/${REPO}/commits?${QUERY}" --hostname "$HOST" --jq "$jq_filter" 2>/dev/null
    else
        gh api "repos/${REPO}/commits?${QUERY}" --jq "$jq_filter" 2>/dev/null
    fi
}

# Get current HEAD SHA
get_head_sha() {
    local jq_filter='.[0].sha'

    if [[ -n "$HOST" ]]; then
        gh api "repos/${REPO}/commits?per_page=1" --hostname "$HOST" --jq "$jq_filter" 2>/dev/null
    else
        gh api "repos/${REPO}/commits?per_page=1" --jq "$jq_filter" 2>/dev/null
    fi
}

commits=$(fetch_commits) || {
    echo "Failed to fetch commits for $REPO" >&2
    exit 1
}

# If we have a since-rev, filter out commits at or before that revision
if [[ -n "$SINCE_REV" ]]; then
    # Filter to only show commits newer than the since-rev
    # (commits come in reverse chronological order, so stop at the since-rev)
    filtered=""
    while IFS= read -r line; do
        sha_prefix="${line%% *}"
        # Check if this line's SHA starts with our since-rev prefix (or vice versa)
        if [[ "$SINCE_REV" == "$sha_prefix"* ]] || [[ "$sha_prefix" == "${SINCE_REV:0:8}"* ]]; then
            break
        fi
        filtered="${filtered}${line}"$'\n'
    done <<< "$commits"
    commits="$filtered"
fi

# Output
if [[ -z "$commits" || "$commits" =~ ^[[:space:]]*$ ]]; then
    echo "No new commits since last evaluation"
    echo ""
    echo "HEAD: $(get_head_sha)"
else
    echo "$commits"
    echo ""
    echo "HEAD: $(get_head_sha)"
fi
