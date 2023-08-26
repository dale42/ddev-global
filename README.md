# DDEV Global

Customizations for my global DDEV directory (~/.ddev).

If you want to use these commands without dropping the repo into your .ddev directory I'd recommend symlinks.

# Custom Commands for WordPress Projects

**Host (commands/host)**

|   |   |
|---|---|
| wp-update | Run WordPress updates via CLI inside the web container |

**Web Container (commands/web)**

|   |   |
|---|---|
| wp-update-commit-core | Runs `wp core update` and commit to repo |
| wp-update-commit-plugins | Runs `wp plugin update` on updatable plugins and commit to repo |
| wp-update-commit-theme  | Runs `wp theme update` on updatable themes and commit to repo |
| wp-update-commit-translations | Runs `wp language update` on core/plugin/theme and commits to repo |

## wp-update

This command:
- Creates a new git repository feature branch off the main branch in the name format: `wp-updates-yyyy-mm-dd`
- Runs the DDEV web container custom commands: `wp-update-commit-core`, `wp-update-commit-plugins`, `wp-update-commit-theme`, and `wp-update-commit-translations`
- The updater should now test the updates and merge the feature branch when satisfied the site isn't broken

**NOTE:** This command uses wp-cli for updating. Many plugins, especially those with licenses, can not be updated with wp-cli, and by extension this command.
