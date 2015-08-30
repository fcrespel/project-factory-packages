#!/bin/bash
#
# Redmine LDAP sync exec script.
# By Fabien CRESPEL <fabien@crespel.net>
#

. "@{product.bin}/loadenv.sh"

REDMINE_DIR="@{package.app}"
LOG_FILE="$REDMINE_DIR/log/ldap_sync.log"
DATE=`date --rfc-3339=seconds`

if [ -e "$REDMINE_DIR" ]; then
(
	cd "$REDMINE_DIR"
	echo "[$DATE]" >> "$LOG_FILE"
	RAILS_ENV=production ACTIVATE_USERS=1 rvm default do bundle exec rake redmine:plugins:ldap_sync:sync_all >> "$LOG_FILE" 2>&1
	echo >> "$LOG_FILE"
)
fi
