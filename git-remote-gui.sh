#!/bin/bash

# Ensure in Git repo
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  yad --error --text="Not inside a Git repository!"
  exit 1
fi

remote_url=$(git remote get-url origin 2>/dev/null)

if [ -z "$remote_url" ]; then
  remote_url="No remote 'origin' set!"
fi

# Show main dialog
result=$(yad --form \
  --title="Git GUI Commit + Push" \
  --width=600 --height=400 \
  --field="Remote URL:RO" "$remote_url" \
  --field="Add all files:CHK" FALSE \
  --field="Commit message:TXT" "" \
  --field="master:CHK" FALSE \
  --field="main:CHK" TRUE \
  --field="Other branch name" "" \
  --button="Push:0" --button="Cancel:1")

ret=$?

if [ "$ret" -ne 0 ]; then
  exit 0
fi

# Parse values
IFS="|" read -r _ add_all commit_msg master_chk main_chk other_branch <<< "$result"

# Determine branch
if [ "$other_branch" != "" ]; then
  branch="$other_branch"
elif [ "$master_chk" == "TRUE" ]; then
  branch="master"
elif [ "$main_chk" == "TRUE" ]; then
  branch="main"
else
  yad --error --text="No branch selected!"
  exit 1
fi

# Ensure commit message
if [ -z "$commit_msg" ]; then
  yad --error --text="Commit message cannot be empty!"
  exit 1
fi

# Add files
if [ "$add_all" == "TRUE" ]; then
  git add .
else
  yad --info --text="Skipping git add (you unchecked 'Add all files')"
fi

# Commit
git commit -m "$commit_msg"

# Push
git push origin "$branch"

yad --info --text="Changes pushed to branch: $branch"
