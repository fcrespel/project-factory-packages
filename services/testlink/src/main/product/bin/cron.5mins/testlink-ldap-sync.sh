#!/bin/bash
#
# TestLink LDAP sync exec script.
# By Fabien CRESPEL <fabien@crespel.net>
#

TESTLINK_DIR="@{package.app}"
SYNC_SCRIPT="$TESTLINK_DIR/custom/ldap_sync.php"
PHP="/usr/bin/php"

PHP_INCLUDE_PATH=".:@{product.app}/system/php/pear/php"
LOG_FILE="@{package.log}/ldap_sync.log"
DATE=`date --rfc-3339=seconds`

if [ -e "$SYNC_SCRIPT" ]; then
	echo "[$DATE]" >> "$LOG_FILE"
	$PHP -d include_path="$PHP_INCLUDE_PATH" "$SYNC_SCRIPT" >> "$LOG_FILE"
	echo >> "$LOG_FILE"
fi
