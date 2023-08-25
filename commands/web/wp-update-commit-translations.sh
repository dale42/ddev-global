#!/bin/bash

## Description: Update WordPress translations via CLI inside the web container
## Usage: wp-update-commit-translations
## Example: "ddev wp-update-commit-translations"
## ProjectTypes: wordpress

if [ "$(git status --short)" != "" ]; then
  echo "The repo is dirty"
  exit 1
fi

wp language core update
wp language plugin update --all
wp language theme update --all

if [ "$(git status --short)" != "" ]; then
  git add .
  git commit -m "WP language translation updates (via update scripte)" | head -n 2
fi
