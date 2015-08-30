#!/bin/bash
#
# Subversion hooks exec script
# By Fabien CRESPEL <fabien@crespel.net>
#

# Script variables
HOOKS_DIR="@{package.data}/hooks"
HOOK_TYPE="$1"
RET=0

if [ -n "$HOOK_TYPE" -a -e "$HOOKS_DIR" ]; then
	shift
	IFS=$'\n'
	for FILE in `find "$HOOKS_DIR" -name "$HOOK_TYPE-*.sh"`; do
		[ -x "$FILE" ] || chmod +x "$FILE"
		if ! "$FILE" "$@"; then
			RET=1
		fi
	done
fi

exit $RET
