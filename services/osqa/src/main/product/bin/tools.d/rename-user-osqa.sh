#!/bin/bash
#
# OSQA user renaming script.
# By Fabien CRESPEL <fabien@crespel.net>
#

# Shared routines
. "@{product.bin}/loadenv.sh"

# Script variables
RENAME_FROM="$1"
RENAME_TO="$2"
OSQA_DIR="@{package.app}"
OSQA_DB="@{osqa.db.name}"

# Check arguments
if [ -z "$RENAME_FROM" -o -z "$RENAME_TO" ]; then
	echo "Usage: $0 <source username> <target username>"
	exit 1
fi

# Check if OSQA directory exists
if [ ! -e "$OSQA_DIR" ]; then
	exit 0
fi

# Update DB
echo "UPDATE auth_user SET username=\"$RENAME_TO\" WHERE username=\"$RENAME_FROM\"" | mysql_exec "$OSQA_DB"
