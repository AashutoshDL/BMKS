#!/bin/bash

# Enhanced Git GUI Script with improved error handling and features

# Check if yad is installed
if ! command -v yad &> /dev/null; then
    echo "Error: yad is not installed. Please install it first."
    echo "Ubuntu/Debian: sudo apt install yad"
    echo "Fedora: sudo dnf install yad"
    echo "Arch: sudo pacman -S yad"
    exit 1
fi

# Check if inside a Git repo
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    yad --error --text="Not inside a Git repository!\n\nPlease run this script from within a Git repository." --width=350
    exit 1
fi

# Get remote URL with better error handling
remote_url=$(git remote get-url origin 2>/dev/null)
if [ -z "$remote_url" ]; then
    remote_url="No remote 'origin' set"
    has_remote=false
else
    has_remote=true
fi

# Get current branch
current_branch=$(git branch --show-current)

# Check if there are any changes to commit
if git diff --quiet && git diff --cached --quiet; then
    yad --info --text="No changes to commit.\n\nWorking directory is clean." --width=300
    exit 0
fi

# Show current repository info
repo_info="Repository: $(basename "$(git rev-parse --show-toplevel)")\nCurrent branch: $current_branch\nRemote: $remote_url"
yad --info --text="$repo_info" --title="Repository Information" --width=400

# Ask how to stage files - simplified to just "Add all files"
stage_choice=$(yad --question \
    --title="Stage Files" \
    --text="Stage all modified and new files?" \
    --button="Yes, add all files:0" \
    --button="Cancel:1" \
    --width=350)

if [ $? -eq 0 ]; then
    git add .
    echo "All files staged successfully."
else
    yad --info --text="Operation canceled." --width=300
    exit 0
fi

# Verify files were staged
if git diff --cached --quiet; then
    yad --error --text="No files were staged!\n\nPlease stage some files before committing." --width=350
    exit 1
fi

# Ask for commit message with better dialog
commit_message=$(yad --form \
    --title="Commit Message" \
    --text="Enter your commit message:" \
    --field="Subject (required):":TEXT \
    --field="Description (optional):":TEXT \
    --width=500 --height=200 \
    --separator="|")

if [ -z "$commit_message" ]; then
    yad --error --text="Commit message cannot be empty!" --width=300
    exit 1
fi

# Parse commit message
IFS="|" read -ra commit_parts <<< "$commit_message"
subject="${commit_parts[0]}"
description="${commit_parts[1]}"

if [ -z "$subject" ]; then
    yad --error --text="Subject line cannot be empty!" --width=300
    exit 1
fi

# Create full commit message
if [ -n "$description" ]; then
    full_message="$subject

$description"
else
    full_message="$subject"
fi

# Show staged changes preview
git diff --cached > /tmp/git_diff.txt
if [ -s /tmp/git_diff.txt ]; then
    yad --text-info --title="Staged Changes Preview" \
        --filename=/tmp/git_diff.txt \
        --width=800 --height=500 \
        --button="Continue:0" --button="Cancel:1"
    
    if [ $? -eq 1 ]; then
        yad --info --text="Operation canceled." --width=300
        rm -f /tmp/git_diff.txt
        exit 0
    fi
fi

# Commit the changes
if ! git commit -m "$full_message"; then
    yad --error --text="Commit failed!\n\nPlease check the terminal for error details." --width=350
    rm -f /tmp/git_diff.txt
    exit 1
fi

# Ask if user wants to push
if [ "$has_remote" = true ]; then
    push_choice=$(yad --question \
        --text="Commit successful!\n\nDo you want to push to remote?" \
        --button="Yes, push now:0" \
        --button="No, commit only:1" \
        --button="Choose branch:2" \
        --width=350)
    
    case $? in
        0)  # Push to current branch
            if git push origin "$current_branch"; then
                yad --info --text="✅ Successfully pushed to '$current_branch'!" --width=350
            else
                yad --error --text="❌ Push failed!\n\nPlease check the terminal for error details." --width=350
                exit 1
            fi
            ;;
        1)  # Commit only
            yad --info --text="✅ Changes committed successfully!\n\nBranch: $current_branch\nCommit: $subject" --width=400
            ;;
        2)  # Choose branch
            # Get all branches (local and remote)
            all_branches=$(git branch -a --format="%(refname:short)" | grep -v HEAD | sort -u)
            
            branch_options=""
            first=true
            while IFS= read -r branch; do
                clean_branch=$(echo "$branch" | sed 's/origin\///')
                if [ "$clean_branch" = "$current_branch" ]; then
                    branch_options+="TRUE|$clean_branch|Current branch|"
                    first=false
                elif [ "$first" = true ]; then
                    branch_options+="TRUE|$clean_branch|Remote branch|"
                    first=false
                else
                    branch_options+="FALSE|$clean_branch|Remote branch|"
                fi
            done <<< "$all_branches"
            
            if [ -n "$branch_options" ]; then
                selected_branch=$(echo "$branch_options" | yad --list --radiolist \
                    --title="Select Branch to Push" \
                    --text="Choose branch to push to:" \
                    --column="Select" --column="Branch" --column="Type" \
                    --width=400 --height=300)
                
                if [ -n "$selected_branch" ]; then
                    if yad --question --text="Push to branch: $selected_branch?" --width=300; then
                        if git push origin "$current_branch:$selected_branch"; then
                            yad --info --text="✅ Successfully pushed to '$selected_branch'!" --width=350
                        else
                            yad --error --text="❌ Push failed!\n\nPlease check the terminal for error details." --width=350
                            exit 1
                        fi
                    else
                        yad --info --text="Push canceled." --width=300
                    fi
                else
                    yad --info --text="No branch selected. Push canceled." --width=300
                fi
            else
                yad --error --text="No branches available for push!" --width=300
            fi
            ;;
    esac
else
    yad --info --text="✅ Changes committed successfully!\n\nBranch: $current_branch\nCommit: $subject\n\nNote: No remote repository configured." --width=400
fi

# Cleanup
rm -f /tmp/git_diff.txt /tmp/git_status.txt

# Show final status
final_status=$(git log --oneline -5)
yad --text-info --title="Recent Commits" \
    --text="$final_status" \
    --width=600 --height=200 \
    --button="Close:0"