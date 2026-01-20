#!/usr/bin/env bash
# Find git repositories by matching their remote origin URL
# Supports bare repos and worktrees, preferring main/master branches
#
# Usage: find-repos.sh <pattern> [path] [max-depth]
# Example: find-repos.sh myorg/api-server ~/workspace
# Example: find-repos.sh "myorg/frontend" ~ 4
# Example: find-repos.sh ""  # list all repos

set -u

PATTERN="${1:-}"
SEARCH_PATH="${2:-$HOME}"
MAX_DEPTH="${3:-5}"

# Expand ~ if present
SEARCH_PATH="${SEARCH_PATH/#\~/$HOME}"

if [ -n "$PATTERN" ]; then
    echo "Searching for repos matching '$PATTERN' in $SEARCH_PATH (max depth: $MAX_DEPTH)..."
else
    echo "Listing all repos in $SEARCH_PATH (max depth: $MAX_DEPTH)..."
fi
echo ""

# Use a temp file to track seen origins (avoids bash 4+ associative arrays)
seen_file=$(mktemp)
trap "rm -f '$seen_file'" EXIT

# Find .git entries (both files for worktrees and directories for regular/bare repos)
find "$SEARCH_PATH" -maxdepth "$MAX_DEPTH" -name .git 2>/dev/null | sort | while read -r gitpath; do
    repo_path=$(dirname "$gitpath")

    # Get the origin remote URL
    url=$(git -C "$repo_path" remote get-url origin 2>/dev/null || echo "")
    if [ -z "$url" ]; then
        continue
    fi

    # Skip if origin doesn't match the pattern
    # Match pattern at word boundary (before .git or end of URL)
    if [ -n "$PATTERN" ] && ! echo "$url" | grep -qiE "$PATTERN(\.git)?$"; then
        continue
    fi

    # Skip if we've already seen this origin
    if grep -qF "$url" "$seen_file" 2>/dev/null; then
        continue
    fi
    echo "$url" >> "$seen_file"

    # Get worktree list for this repo
    worktrees=$(git -C "$repo_path" worktree list 2>/dev/null || echo "")
    if [ -z "$worktrees" ]; then
        continue
    fi

    echo "=== $url ==="

    # Parse each worktree and mark preferred branches
    while IFS= read -r wt_line; do
        wt_path=$(echo "$wt_line" | awk '{print $1}')
        wt_info=$(echo "$wt_line" | sed 's|^[^ ]* *||')

        # Check if this is main/master or bare
        if echo "$wt_info" | grep -qE '\[(main|master)\]'; then
            echo "  $wt_path $wt_info [PREFERRED]"
        elif echo "$wt_info" | grep -q '(bare)'; then
            echo "  $wt_path $wt_info"
        else
            echo "  $wt_path $wt_info"
        fi
    done <<< "$worktrees"

    echo ""
done
