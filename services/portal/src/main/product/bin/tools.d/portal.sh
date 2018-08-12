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
	echo "       $0 config show"
	echo "       $0 config get <path>"
	echo "       $0 config set <path> <value>"
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
	"config")
		CONFIG_ACTION="$2"
		CONFIG_FILE="@{package.data}/config.inc.php"
		
		# Check arguments
		if [ -z "$CONFIG_ACTION" ]; then
			echo "Usage: $0 config show"
			echo "       $0 config get <path>"
			echo "       $0 config set <path> <value>"
			exit 1
		fi
		
		# Perform action
		case "$CONFIG_ACTION" in
			"show")
				php -r "\$config = include('$CONFIG_FILE'); echo json_encode(\$config, JSON_PRETTY_PRINT) . \"\\n\";"
				;;
			"get")
				CONFIG_PATH="$3"
				if [ -z "$CONFIG_PATH" ]; then
					echo "Usage: $0 config get <path>"
					exit 1
				fi
				CONFIG_PATH="['"$(echo "$CONFIG_PATH" | sed "s#\.#']['#g")"']"
				php -r "\$config = include('$CONFIG_FILE'); echo \$config${CONFIG_PATH} . \"\\n\";"
				;;
			"set")
				CONFIG_PATH="$3"
				CONFIG_VALUE="$4"
				if [ -z "$CONFIG_PATH" ]; then
					echo "Usage: $0 config set <path> <value>"
					exit 1
				fi
				CONFIG_PATH="['"$(echo "$CONFIG_PATH" | sed "s#\.#']['#g")"']"
				if [ "$CONFIG_VALUE" != "true" -a "$CONFIG_VALUE" != "false" ]; then
					CONFIG_VALUE='"'$(echo "$CONFIG_VALUE" | sed 's#"#\\"#g')'"'
				fi
				CONFIG_FILE_TMP=`mktemp`
				if php -r "\$config = include('$CONFIG_FILE'); \$config${CONFIG_PATH} = $CONFIG_VALUE; echo \"<?php\\n// Local configuration\\nreturn \".var_export(\$config, true).\";\\n\";" > "$CONFIG_FILE_TMP"; then
					cat "$CONFIG_FILE_TMP" > "$CONFIG_FILE"
				fi
				rm -f "$CONFIG_FILE_TMP"
				;;
			*)
				echo "Unknown config action '$CONFIG_ACTION'"
				;;
		esac
		;;
	*)
		echo "Unknown action '$ACTION'"
		;;
esac
