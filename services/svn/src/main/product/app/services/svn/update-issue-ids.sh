#!/bin/bash
#
# Utility script to update all issues IDs (e.g. #123) by an offset in SVN commit logs.
# By Fabien Crespel <fabien@crespel.net>
#

REPOS_DIR="@{package.data}/repos"

if [ $# -lt 2 ]; then
	echo "Usage: $0 <repo> <offset>"
	exit 1
fi

REPO_NAME="$1"
REPO_DIR="$REPOS_DIR/$REPO_NAME"
if [ ! -e "$REPO_DIR" ]; then
	echo "Repository $REPO_NAME does not exist."
	exit 1
fi

ISSUE_OFFSET="$2"
ISSUE_SORT=""
if [ $ISSUE_OFFSET -gt 0 ]; then
	ISSUE_SORT="-r"
fi

REV_LAST=`svnlook youngest "$REPO_DIR"`
REV_CUR=1
while [ $REV_CUR -le $REV_LAST ]; do
	REV_LOG=`svnlook log "$REPO_DIR" --revision $REV_CUR`
	if ( echo "$REV_LOG" | grep -q '#' ); then
		echo "Revision $REV_CUR:"
		for ISSUE_ID in `echo "$REV_LOG" | grep -oP '#\d+' | grep -oP '\d+' | sort $ISSUE_SORT`; do
			ISSUE_NEW=`expr $ISSUE_ID + $ISSUE_OFFSET`
			echo "- $ISSUE_ID => $ISSUE_NEW"
			REV_LOG=`echo "$REV_LOG" | sed -r "s/#($ISSUE_ID)([^0-9]|$$)/#$ISSUE_NEW\\2/g"`
		done
		REV_LOG_FILE=`mktemp`
		echo -n "$REV_LOG" > "$REV_LOG_FILE"
		svnadmin setlog "$REPO_DIR" -r $REV_CUR --bypass-hooks "$REV_LOG_FILE"
		rm -f "$REV_LOG_FILE"
	fi
	REV_CUR=`expr $REV_CUR + 1`
done
