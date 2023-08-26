#!/bin/bash

## Description: Run WordPress core update via CLI inside the web container
## Usage: wp-update-commit-core
## Example: "ddev wp-update-commit-core"
## ProjectTypes: wordpress

if [ "$(git status --short)" != "" ]; then
  echo "The repo is dirty"
  exit 1
fi

startingWpVersion=$(wp core version)

wp core update

if [ $? -ne 0 ]; then
  exit $?
fi

endingWpVersion=$(wp core version)

echo ""

git add .
git commit -m "WP core update $startingWpVersion -> $endingWpVersion (via update script)"  | head -n 2
