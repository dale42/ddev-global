#!/bin/bash

## Description: Run WordPress theme updates via CLI inside the web container
## Usage: wp-update-commit-theme
## Example: "ddev wp-update-commit-theme"
## ProjectTypes: wordpress

if [ "$(git status --short)" != "" ]; then
  echo "The repo is dirty"
  exit 1
fi

# Get a list of plugins requiring updating
themeListString=$(wp theme list --update=available --format=csv --fields=name,version,update_version)
themeListString=$(echo "$themeListString" | tr '\n' "#")
IFS='#' read -r -a themeList <<< "$themeListString"
unset "themeList[0]"

# Do the updates
for element in "${themeList[@]}"
do
  themeName=$(echo $element | cut -d',' -f1)
  startVersion=$(echo $element | cut -d',' -f2)
  endVersion=$(echo $element | cut -d',' -f3)

  echo "Updating theme $themeName $startVersion -> $endVersion"
  wp theme update $themeName

  if [ $? -ne 0 ]; then
    exit $?
  fi

  echo ""

  git add .
  git commit -m "WP theme update: $themeName $startVersion -> $endVersion (via update script)" | head -n 2
done
