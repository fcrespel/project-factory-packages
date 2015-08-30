#!/bin/bash
#
# Redmine Jenkins sync exec script.
# By Fabien CRESPEL <fabien@crespel.net>
#

. "@{product.bin}/loadenv.sh"

REDMINE_DIR="@{package.app}"
LOG_FILE="$REDMINE_DIR/log/jenkins_sync.log"
DATE=`date --rfc-3339=seconds`

if [ -e "$REDMINE_DIR" ]; then
(
	cd "$REDMINE_DIR"
	echo "[$DATE]" >> "$LOG_FILE"
	RAILS_ENV=production rvm default do bundle exec rake redmine_hudson:fetch >> "$LOG_FILE" 2>&1
	echo >> "$LOG_FILE"
)
fi
