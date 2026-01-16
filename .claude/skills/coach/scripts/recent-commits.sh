#!/bin/bash
#
# Fetch recent commits from repos listed in .gitmodules
#
# Usage: recent-commits.sh [--author <name-or-email>] [--limit <n>]
#
# Options:
#   --author    Filter commits to those by this author (partial match on name or email)
#   --limit     Number of commits per repo (default: 10)
#
# Requires: gh (GitHub CLI) authenticated
# Supports: github.com and GitHub Enterprise instances
#

set -euo pipefail

AUTHOR=""
LIMIT=10

while [[ $# -gt 0 ]]; do
    case $1 in
        --author)
            AUTHOR="$2"
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

# Find .gitmodules in current directory or parents
find_gitmodules() {
    local dir="$PWD"
    while [[ "$dir" != "/" ]]; do
        if [[ -f "$dir/.gitmodules" ]]; then
            echo "$dir/.gitmodules"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    return 1
}

GITMODULES=$(find_gitmodules) || {
    echo "No .gitmodules found" >&2
    exit 1
}

# Extract URLs from .gitmodules
extract_urls() {
    grep -E '^\s*url\s*=' "$GITMODULES" | sed 's/.*=\s*//' | tr -d ' '
}

# Extract host from git URL
# Returns empty string for github.com (default), otherwise the GHE hostname
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
    # Handle various URL formats:
    # https://github.com/owner/repo.git
    # https://github.example.com/owner/repo.git
    # git@github.com:owner/repo.git
    # git@github.example.com:owner/repo.git
    echo "$url" | sed -E 's|^https?://[^/]+/||; s|^git@[^:]+:||; s|\.git$||'
}

# Fetch commits for a repo
fetch_commits() {
    local repo="$1"
    local host="$2"
    local jq_filter

    if [[ -n "$AUTHOR" ]]; then
        # Filter by author (case-insensitive partial match on name or email)
        # Embed the lowercase author directly in the jq filter since gh api doesn't support --arg
        local author_lower
        author_lower=$(echo "$AUTHOR" | tr '[:upper:]' '[:lower:]')
        jq_filter=".[] | select((.commit.author.name | ascii_downcase | contains(\"${author_lower}\")) or (.commit.author.email | ascii_downcase | contains(\"${author_lower}\"))) | \"\(.commit.author.date | split(\"T\")[0]) \(.commit.message | split(\"\n\")[0])\""
    else
        jq_filter='.[] | "\(.commit.author.date | split("T")[0]) \(.commit.author.name): \(.commit.message | split("\n")[0])"'
    fi

    # Use --hostname for GitHub Enterprise, omit for github.com
    if [[ -n "$host" ]]; then
        gh api "repos/${repo}/commits?per_page=${LIMIT}" --hostname "$host" --jq "$jq_filter" 2>/dev/null
    else
        gh api "repos/${repo}/commits?per_page=${LIMIT}" --jq "$jq_filter" 2>/dev/null
    fi
}

# Main
for url in $(extract_urls); do
    repo=$(url_to_repo "$url")
    host=$(url_to_host "$url")

    if [[ -z "$repo" ]]; then
        continue
    fi

    commits=$(fetch_commits "$repo" "$host" 2>/dev/null) || continue

    if [[ -n "$commits" ]]; then
        echo "## $repo"
        echo "$commits"
        echo ""
    fi
done
