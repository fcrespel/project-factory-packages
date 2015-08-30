#!/bin/bash
#
# SVN user renaming script.
# By Fabien CRESPEL <fabien@crespel.net>
#

# Shared routines
. "@{product.bin}/loadenv.sh"

# Script variables
RENAME_FROM="$1"
RENAME_TO="$2"
REPOS_DIR="@{package.data}/repos"

# Check arguments
if [ -z "$RENAME_FROM" -o -z "$RENAME_TO" ]; then
	echo "Usage: $0 <source username> <target username>"
	exit 1
fi

# Check if repos directory exists
if [ ! -e "$REPOS_DIR" ]; then
	exit 0
fi

# Create the author property file
REV_PROP_FILE=`mktemp --tmpdir=$PRODUCT_TMP`
echo -n "$RENAME_TO" > "$REV_PROP_FILE"

# Process each repository
find "$REPOS_DIR" -mindepth 1 -maxdepth 1 -type d | while read REPO_DIR; do
	REV_LAST=`svnlook youngest "$REPO_DIR"`
	REV_CUR=1
	echo "Processing repository $REPO_DIR ..."
	while [ $REV_CUR -le $REV_LAST ]; do
		REV_AUTHOR=`svnlook author "$REPO_DIR" --revision $REV_CUR`
		if [ "$REV_AUTHOR" = "$RENAME_FROM" ]; then
			echo "- Revision $REV_CUR"
			svnadmin setrevprop "$REPO_DIR" -r $REV_CUR 'svn:author' "$REV_PROP_FILE"
		fi
		REV_CUR=`expr $REV_CUR + 1`
	done
done

rm -f "$REV_PROP_FILE"
