#!/bin/bash
#
# Piwik archive script.
# By Fabien CRESPEL <fabien@crespel.net>
#

PIWIK_DIR="@{package.app}"
PIWIK_URL="@{product.scheme}://@{product.domain}/admin/piwik/"
CONSOLE_SCRIPT="$PIWIK_DIR/console"
PHP="/usr/bin/php"

LOG_FILE="@{package.log}/archive.log"
DATE=`date --rfc-3339=seconds`

if [ -e "$CONSOLE_SCRIPT" ]; then
	echo "[$DATE]" >> "$LOG_FILE"
	$PHP "$CONSOLE_SCRIPT" core:archive --url=$PIWIK_URL >> "$LOG_FILE" 2>&1
	echo >> "$LOG_FILE"
fi
