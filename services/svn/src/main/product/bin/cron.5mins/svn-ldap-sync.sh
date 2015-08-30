#!/bin/bash
#
# Subversion LDAP sync exec script.
# By Fabien CRESPEL <fabien@crespel.net>
#

SYNC_SCRIPT="@{package.app}/ldap_sync.sh"
LOG_FILE="@{package.log}/ldap_sync.log"
DATE=`date --rfc-3339=seconds`

if [ -e "$SYNC_SCRIPT" ]; then
	echo "[$DATE]" >> "$LOG_FILE"
	$SYNC_SCRIPT >> "$LOG_FILE"
	echo >> "$LOG_FILE"
fi
