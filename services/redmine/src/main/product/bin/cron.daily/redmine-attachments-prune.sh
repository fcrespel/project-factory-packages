#!/bin/bash
#
# Redmine attachments prune script.
# By Fabien CRESPEL <fabien@crespel.net>
#

. "@{product.bin}/loadenv.sh"

REDMINE_DIR="@{package.app}"

if [ -e "$REDMINE_DIR" ]; then
(
	cd "$REDMINE_DIR"
	RAILS_ENV=production rvm @{ruby.version} do bundle exec rake redmine:attachments:prune > /dev/null 2>&1
)
fi
