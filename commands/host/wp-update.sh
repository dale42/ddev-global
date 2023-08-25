#!/bin/bash

## Description: Run WordPress updates via CLI inside the web container
## Usage: wp-update
## Example: "ddev wp-update"
## ProjectTypes: wordpress

#wp "$@"

DATE="$(date +%Y%b%d)"

#echo "Date: $DATE"
#echo "Current branch: $CURRENT_BRANCH"

function confirmOnGitMainBranch() {
  CURRENT_BRANCH="$(git symbolic-ref --short HEAD)"
  if [ "main" != "$CURRENT_BRANCH" ]; then
    echo "Repo must be on main"
    exit
  fi
}

function confirmRepoClean() {
  if [ "$(git status --short)" != "" ]; then
    echo "The repo is dirty"
    exit 1
  fi
}

function setUpdateBranch() {
  UPDATE_BRANCH_NAME="wp-updates-$(date +%Y%b%d)"
  git checkout -b "$UPDATE_BRANCH_NAME"
}

confirmOnGitMainBranch
confirmRepoClean
setUpdateBranch
ddev wp-update-commit-core
ddev wp-update-commit-plugins
ddev wp-update-commit-theme
ddev wp-update-commit-translations
