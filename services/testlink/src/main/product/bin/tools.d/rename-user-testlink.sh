#!/bin/bash
#
# TestLink user renaming script.
# By Fabien CRESPEL <fabien@crespel.net>
#

# Shared routines
. "@{product.bin}/loadenv.sh"

# Script variables
RENAME_FROM="$1"
RENAME_TO="$2"
TESTLINK_DIR="@{package.app}"
TESTLINK_DB="@{testlink.db.name}"

# Check arguments
if [ -z "$RENAME_FROM" -o -z "$RENAME_TO" ]; then
	echo "Usage: $0 <source username> <target username>"
	exit 1
fi

# Check if TestLink directory exists
if [ ! -e "$TESTLINK_DIR" ]; then
	exit 0
fi

# Update DB
echo "UPDATE users SET login=\"$RENAME_TO\" WHERE login=\"$RENAME_FROM\"" | mysql_exec "$TESTLINK_DB"
