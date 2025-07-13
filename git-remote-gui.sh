#!/bin/bash

# This ensures we are in a Git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    zenity --error --text="Not inside a Git repository!"
    exit 1
fi

# This gets the remote URL
remote_url=$(git remote get-url origin 2>/dev/null)

# Check if remote exists
if [ -z "$remote_url" ]; then
    zenity --warning --text="No remote 'origin' set for this repo."
else
    zenity --info --title="Git Remote Info" --text="Connected Remote:\n$remote_url"
fi

# Prompt user to enter commit message
commit_message=$(zenity --entry \
    --title="Enter Commit Message" \
    --text="Please enter your Git commit message:")

# Check if message is empty
if [ -z "$commit_message" ]; then
    zenity --error --text="Commit message cannot be empty!"
    exit 1
fi

# Stage all files
git add .

# Commit with the entered message
git commit -m "$commit_message"

# Optional: show success message
zenity --info --text="Changes committed with message:\n$commit_message"

