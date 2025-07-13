#!/bin/bash

# Check if inside a Git repo
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  zenity --error --text="Not inside a Git repository!"
  exit 1
fi

# Get remote URL
remote_url=$(git remote get-url origin 2>/dev/null)

if [ -z "$remote_url" ]; then
  zenity --warning --text="No remote 'origin' set for this repo."
else
  zenity --info --title="Git Remote Info" --text="Connected Remote:\n$remote_url"
fi

# Ask for commit message
commit_message=$(zenity --entry \
  --title="Enter Commit Message" \
  --text="Please enter your Git commit message:")

if [ -z "$commit_message" ]; then
  zenity --error --text="Commit message cannot be empty!"
  exit 1
fi

# Branch selection dialog with options and "Other"
branch=$(zenity --list --radiolist \
  --title="Select Branch to Commit & Push" \
  --text="Choose a branch or select 'Other' to specify:" \
  --column="Select" --column="Branch" \
  TRUE "main" \
  FALSE "master" \
  FALSE "Other")

if [ "$branch" == "Other" ]; then
  branch=$(zenity --entry --title="Custom Branch" --text="Enter branch name:")
  if [ -z "$branch" ]; then
    zenity --error --text="Branch name cannot be empty!"
    exit 1
  fi
fi

# Stage all changes
git add .

# Commit
git commit -m "$commit_message"

# Confirm push
if zenity --question --text="Push changes to origin/$branch?"; then
  git push origin "$branch"
  zenity --info --text="Changes pushed to $branch!"
else
  zenity --info --text="Push canceled."
fi

