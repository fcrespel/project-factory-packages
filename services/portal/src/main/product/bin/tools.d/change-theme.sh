#!/bin/bash
#
# Product theme changing script.
# By Fabien CRESPEL <fabien@crespel.net>
#

# Shared routines
SCRIPT_DIR=`dirname "$0"`
. "$SCRIPT_DIR/../loadenv.sh"

# Script variables
NEW_THEME="$1"
THEME_DIR="@{package.app}/themes"

# Check arguments
if [ -z "$NEW_THEME" -o "$NEW_THEME" = "default" ]; then
	echo "Usage: $0 <new theme>"
	echo "Available themes: "
	find "$THEME_DIR" -mindepth 1 -maxdepth 1 -type d -printf "  %f\n" | sort
	exit 1
fi
if [ ! -e "$THEME_DIR/$NEW_THEME" ]; then
	echo "Theme '$NEW_THEME' does not exist"
	exit 1
fi

# Set the new theme
storevar PRODUCT_THEME "$NEW_THEME"
rm -f "$THEME_DIR/default" && ln -s "$NEW_THEME" "$THEME_DIR/default"
