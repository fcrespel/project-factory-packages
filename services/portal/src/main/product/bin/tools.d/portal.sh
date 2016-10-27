#!/bin/bash
#
# Portal management script.
# By Fabien CRESPEL <fabien@crespel.net>
#

# Shared routines
SCRIPT_DIR=`dirname "$0"`
. "$SCRIPT_DIR/../loadenv.sh"

# Script variables
ACTION="$1"

# Check arguments
if [ -z "$ACTION" ]; then
	echo "Usage: $0 theme <new theme>"
	exit 1
fi

# Perform action
case "$ACTION" in
	"theme")
		THEME_NAME="$2"
		THEME_DIR="@{package.app}/themes"
		
		# Check arguments
		if [ -z "$THEME_NAME" -o "$THEME_NAME" = "default" ]; then
			echo "Usage: $0 theme <new theme>"
			echo "Available themes: "
			find "$THEME_DIR" -mindepth 1 -maxdepth 1 -type d -printf "  %f\n" | sort
			exit 1
		fi
		if [ ! -e "$THEME_DIR/$THEME_NAME" ]; then
			echo "Theme '$THEME_NAME' does not exist"
			exit 1
		fi
		
		# Set the new theme
		storevar PRODUCT_THEME "$THEME_NAME"
		rm -f "$THEME_DIR/default" && ln -s "$THEME_NAME" "$THEME_DIR/default"
		chown -h $PRODUCT_USER:$PRODUCT_GROUP "$THEME_DIR/default"
		echo "Theme changed to '$THEME_NAME'"
		;;
	*)
		echo "Unknown action '$ACTION'"
		;;
esac
