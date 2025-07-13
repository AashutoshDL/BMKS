#!/bin/bash

# Simple Git GUI - One dialog to rule them all

# Check if yad is installed
if ! command -v yad &> /dev/null; then
    echo "Error: yad is not installed. Please install it first."
    exit 1
fi

# Check if inside a Git repo
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    yad --error --text="Not inside a Git repository!" --width=300
    exit 1
fi

# Check if there are changes to commit
if git diff --quiet && git diff --cached --quiet; then
    yad --info --text="No changes to commit." --width=300
    exit 0
fi

# Get current info
remote_url=$(git remote get-url origin 2>/dev/null || echo "No remote set")
current_branch=$(git branch --show-current)
all_branches=$(git branch --format="%(refname:short)" | tr '\n' '!')

# Single dialog with all options
result=$(yad --form \
    --title="Git Push Tool" \
    --text="Repository: $(basename "$(pwd)")" \
    --field="Remote URL:":RO "$remote_url" \
    --field="Add all files:":CHK "TRUE" \
    --field="Commit message:":TEXT "" \
    --field="Branch:":CB "$current_branch!$all_branches" \
    --field="Custom branch name:":TEXT "" \
    --button="Push:0" \
    --button="Cancel:1" \
    --width=500 --height=300 \
    --separator="|")

# Check if canceled
if [ $? -eq 1 ]; then
    exit 0
fi

# Parse results
IFS="|" read -ra values <<< "$result"
remote="${values[0]}"
add_all="${values[1]}"
commit_msg="${values[2]}"
selected_branch="${values[3]}"
custom_branch="${values[4]}"

# Validate commit message
if [ -z "$commit_msg" ]; then
    yad --error --text="Commit message cannot be empty!" --width=300
    exit 1
fi

# Determine target branch
if [ -n "$custom_branch" ]; then
    target_branch="$custom_branch"
else
    target_branch="$selected_branch"
fi

# Stage files if requested
if [ "$add_all" = "TRUE" ]; then
    git add .
fi

# Check if anything is staged
if git diff --cached --quiet; then
    yad --error --text="No files staged for commit!" --width=300
    exit 1
fi

# Commit and push
if git commit -m "$commit_msg"; then
    if [ "$remote_url" != "No remote set" ]; then
        if git push -u origin "$target_branch"; then
            yad --info --text="✅ Successfully pushed to '$target_branch'!" --width=350
        else
            yad --error --text="❌ Push failed! Check terminal for details." --width=350
            exit 1
        fi
    else
        yad --info --text="✅ Committed successfully!\n(No remote configured)" --width=350
    fi
else
    yad --error --text="❌ Commit failed! Check terminal for details." --width=350
    exit 1
fi