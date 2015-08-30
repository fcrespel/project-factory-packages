#!/bin/bash
#
# Redmine user renaming script.
# By Fabien CRESPEL <fabien@crespel.net>
#

# Shared routines
. "@{product.bin}/loadenv.sh"

# Script variables
RENAME_FROM="$1"
RENAME_TO="$2"
REDMINE_DIR="@{package.app}"
REDMINE_DB="@{redmine.db.name}"

# Check arguments
if [ -z "$RENAME_FROM" -o -z "$RENAME_TO" ]; then
	echo "Usage: $0 <source username> <target username>"
	exit 1
fi

# Check if Redmine directory exists
if [ ! -e "$REDMINE_DIR" ]; then
	exit 0
fi

# Update DB
echo "UPDATE users SET login=\"$RENAME_TO\" WHERE login=\"$RENAME_FROM\"" | mysql_exec "$REDMINE_DB"
echo "UPDATE changesets SET committer=\"$RENAME_TO\" WHERE committer=\"$RENAME_FROM\"" | mysql_exec "$REDMINE_DB"
