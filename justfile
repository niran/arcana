# Start the docs development server
docs:
    cd docs && npm start

# Build the docs for production
docs-build:
    cd docs && npm run build

# Install docs dependencies
docs-install:
    cd docs && npm install

# Check which submodules are outdated compared to their upstream branches
check-submodules:
    #!/usr/bin/env bash
    set -euo pipefail

    outdated=0
    while IFS= read -r line; do
        path=$(echo "$line" | awk '{print $2}')
        config_name="$path"
        url=$(git config --file .gitmodules --get submodule."$config_name".url 2>/dev/null || true)
        branch=$(git config --file .gitmodules --get submodule."$config_name".branch 2>/dev/null || true)

        if [ -z "$url" ]; then
            alt_name=$(basename "$path")
            url=$(git config --file .gitmodules --get submodule."$alt_name".url 2>/dev/null || true)
            branch=$(git config --file .gitmodules --get submodule."$alt_name".branch 2>/dev/null || true)
        fi

        if [ -z "$url" ] || [ -z "$branch" ]; then
            echo "  $path: could not determine url or branch"
            continue
        fi

        current=$(git ls-tree HEAD "$path" 2>/dev/null | awk '{print $3}')
        latest=$(git ls-remote "$url" "refs/heads/$branch" 2>/dev/null | cut -f1)

        if [ -z "$latest" ]; then
            echo "  $path: could not fetch latest from $branch"
        elif [ "$current" != "$latest" ]; then
            echo " $path: outdated"
            echo "   current: ${current:0:12}"
            echo "   latest:  ${latest:0:12}"
            outdated=$((outdated + 1))
        fi
    done < <(git config --file .gitmodules --get-regexp '^submodule\..*\.path$' 2>/dev/null || true)

    if [ $outdated -eq 0 ]; then
        echo " All submodules are up to date (or no submodules configured)"
    else
        echo ""
        echo "Found $outdated outdated submodule(s). Run 'just update-submodules' to update."
        exit 1
    fi

# Update all submodules to the latest commit on their configured branches
update-submodules:
    #!/usr/bin/env bash
    set -euo pipefail

    updated=0
    while IFS= read -r line; do
        path=$(echo "$line" | awk '{print $2}')
        config_name="$path"
        url=$(git config --file .gitmodules --get submodule."$config_name".url 2>/dev/null || true)
        branch=$(git config --file .gitmodules --get submodule."$config_name".branch 2>/dev/null || true)

        if [ -z "$url" ]; then
            alt_name=$(basename "$path")
            url=$(git config --file .gitmodules --get submodule."$alt_name".url 2>/dev/null || true)
            branch=$(git config --file .gitmodules --get submodule."$alt_name".branch 2>/dev/null || true)
        fi

        if [ -z "$url" ] || [ -z "$branch" ]; then
            echo "  $path: skipping (could not determine url or branch)"
            continue
        fi

        current=$(git ls-tree HEAD "$path" 2>/dev/null | awk '{print $3}')
        latest=$(git ls-remote "$url" "refs/heads/$branch" 2>/dev/null | cut -f1)

        if [ -z "$latest" ]; then
            echo "⚠️  $path: could not fetch latest from $branch"
        elif [ "$current" != "$latest" ]; then
            # Check if submodule is checked out (has a .git file/directory)
            if [ -e "$path/.git" ]; then
                # Submodule is checked out - fetch and checkout the new commit
                echo "📦 $path: checked out, updating working tree..."
                git -C "$path" fetch origin "$branch"
                git -C "$path" checkout "$latest"
            fi
            git update-index --cacheinfo 160000,"$latest","$path"
            echo "✅ $path: updated to ${latest:0:12}"
            updated=$((updated + 1))
        fi
    done < <(git config --file .gitmodules --get-regexp '^submodule\..*\.path$' 2>/dev/null || true)

    if [ $updated -eq 0 ]; then
        echo "No submodules needed updating"
    else
        echo ""
        echo "Updated $updated submodule(s). Review with 'git diff --cached' and commit when ready."
    fi
