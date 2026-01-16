#!/bin/bash
#
# Parse the staleness log and extract repo evaluation info
#
# Usage: parse-staleness.sh [--repo <name>] [--stale-days <n>]
#
# Options:
#   --repo        Show info for a specific repo only
#   --stale-days  Only show repos not evaluated in this many days (default: show all)
#
# Output format (TSV):
#   repo_name<TAB>last_evaluated<TAB>docs_updated<TAB>revision<TAB>revision_date<TAB>notes
#

set -euo pipefail

REPO_FILTER=""
STALE_DAYS=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --repo)
            REPO_FILTER="$2"
            shift 2
            ;;
        --stale-days)
            STALE_DAYS="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
    esac
done

# Find the staleness.md file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARCANA_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
STALENESS_FILE="$ARCANA_ROOT/docs/docs/reference/staleness.md"

if [[ ! -f "$STALENESS_FILE" ]]; then
    echo "Staleness file not found: $STALENESS_FILE" >&2
    exit 1
fi

# Calculate cutoff date if stale-days is specified
CUTOFF_DATE=""
if [[ -n "$STALE_DAYS" ]]; then
    if [[ "$(uname)" == "Darwin" ]]; then
        CUTOFF_DATE=$(date -v-${STALE_DAYS}d +%Y-%m-%d)
    else
        CUTOFF_DATE=$(date -d "-${STALE_DAYS} days" +%Y-%m-%d)
    fi
fi

# Parse the evaluation log table
# Skip header rows, parse each data row
in_table=false
while IFS= read -r line; do
    # Detect table start (header row with "Repo")
    if [[ "$line" =~ ^\|[[:space:]]*Repo[[:space:]]*\| ]]; then
        in_table=true
        continue
    fi

    # Skip separator row
    if [[ "$line" =~ ^\|[-]+\| ]]; then
        continue
    fi

    # Detect table end (empty line or new section)
    if [[ "$in_table" == true ]] && [[ ! "$line" =~ ^\| ]]; then
        break
    fi

    # Parse data rows
    if [[ "$in_table" == true ]] && [[ "$line" =~ ^\| ]]; then
        # Remove leading/trailing pipes and split by |
        cleaned=$(echo "$line" | sed 's/^|//; s/|$//')

        # Extract fields (handle pipes within cells)
        repo=$(echo "$cleaned" | awk -F'|' '{gsub(/^[[:space:]]+|[[:space:]]+$/, "", $1); print $1}')
        last_eval=$(echo "$cleaned" | awk -F'|' '{gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2); print $2}')
        docs_updated=$(echo "$cleaned" | awk -F'|' '{gsub(/^[[:space:]]+|[[:space:]]+$/, "", $3); print $3}')
        revision=$(echo "$cleaned" | awk -F'|' '{gsub(/^[[:space:]]+|[[:space:]]+$/, "", $4); print $4}')
        rev_date=$(echo "$cleaned" | awk -F'|' '{gsub(/^[[:space:]]+|[[:space:]]+$/, "", $5); print $5}')
        notes=$(echo "$cleaned" | awk -F'|' '{gsub(/^[[:space:]]+|[[:space:]]+$/, "", $6); print $6}')

        # Apply repo filter if specified
        if [[ -n "$REPO_FILTER" ]]; then
            if [[ "$repo" != *"$REPO_FILTER"* ]]; then
                continue
            fi
        fi

        # Apply staleness filter if specified
        if [[ -n "$CUTOFF_DATE" ]] && [[ -n "$last_eval" ]]; then
            if [[ "$last_eval" > "$CUTOFF_DATE" ]] || [[ "$last_eval" == "$CUTOFF_DATE" ]]; then
                continue
            fi
        fi

        # Output in TSV format
        printf "%s\t%s\t%s\t%s\t%s\t%s\n" "$repo" "$last_eval" "$docs_updated" "$revision" "$rev_date" "$notes"
    fi
done < "$STALENESS_FILE"
