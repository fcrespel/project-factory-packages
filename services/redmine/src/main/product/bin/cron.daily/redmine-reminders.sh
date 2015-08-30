#!/bin/bash
#
# Redmine reminders exec script.
# By Fabien CRESPEL <fabien@crespel.net>
#

. "@{product.bin}/loadenv.sh"

DAYS=3
REDMINE_DIR="@{package.app}"

if [ -e "$REDMINE_DIR" ]; then
(
	cd "$REDMINE_DIR"
	RAILS_ENV=production rvm default do bundle exec rake redmine:send_reminders days=$DAYS > /dev/null 2>&1
)
fi
