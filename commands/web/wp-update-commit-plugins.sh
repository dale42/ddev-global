#!/bin/bash
#
# Update WordPress core using wp-cli and commit to repo
# with a nice commit message.
#
## Description: Update WordPress core using wp-cli and commit to repo inside the web container
## Usage: wp-update-commit-plugins
## Example: "ddev wp-update-commit-plugins"
## ProjectTypes: wordpress

if [ "$(git status --short)" != "" ]; then
  echo "The repo is dirty"
  exit 1
fi

# Get a list of plugins requiring updating
pluginListString=$(wp plugin list --update=available --format=csv --fields=name,version,update_version)
pluginListString=$(echo "$pluginListString" | tr '\n' "#")
IFS='#' read -r -a pluginList <<< "$pluginListString"
unset "pluginList[0]"

# Do the updates
for element in "${pluginList[@]}"
do
  pluginName=$(echo $element | cut -d',' -f1)
  startVersion=$(echo $element | cut -d',' -f2)
  endVersion=$(echo $element | cut -d',' -f3)

  echo "Updating plugin $pluginName $startVersion -> $endVersion"
  wp plugin update $pluginName

  if [ $? -ne 0 ]; then
    exit $?
  fi

  echo ""

  git add .
  git commit -m "WP plugin update: $pluginName $startVersion -> $endVersion (via update script)" | head -n 2
done
