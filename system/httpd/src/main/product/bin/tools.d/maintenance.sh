#!/bin/bash
#
# Maintenance toggle script.
# By Fabien CRESPEL <fabien@crespel.net>
#

# Shared routines
SCRIPT_DIR=`dirname "$0"`
. "$SCRIPT_DIR/../loadenv.sh"

# Script variables
ACTION="$1"
SERVICE_NAME="$2"

# Check arguments
if [ -z "$ACTION" ]; then
	echo "Usage: $0 <enable|disable> [service name]"
	exit 1
fi

# Perform action
case "$ACTION" in
	"enable")
		if [ -n "$SERVICE_NAME" ]; then
			httpd_disable_service "$SERVICE_NAME"
		else
			httpd_disable_platform
		fi
		;;
	"disable")
		if [ -n "$SERVICE_NAME" ]; then
			httpd_enable_service "$SERVICE_NAME"
		else
			httpd_enable_platform
		fi
		;;
	*)
		echo "Unknown action '$ACTION'"
		;;
esac
