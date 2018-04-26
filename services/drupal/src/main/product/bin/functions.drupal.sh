#!/bin/bash
#
# Project Factory - Drupal Functions
# By Fabien CRESPEL <fabien@crespel.net>
#

# Execute a Drush command for the platform site
function drush
{
	local DRUPAL_APP="@{package.app}"
	local DRUSH="$DRUPAL_APP/scripts/drush.phar"
	[ -x "$DRUSH" ] || chmod +x "$DRUSH"
	"$DRUSH" --root="$DRUPAL_APP" --uri="http://$PRODUCT_DOMAIN/drupal/" --yes "$@"
}

# Execute a Drush command without displaying the output
function drush_quiet
{
	drush "$@" > /dev/null 2>&1
}
