#!/bin/sh
# Redmine commit notification hook

. "@{product.bin}/loadenv.sh"

REPOS="$1"
REV="$2"
REDMINE_DIR="@{product.app}/services/redmine"

if [ -e "$REDMINE_DIR" ]; then
(
	cd "$REDMINE_DIR"
	echo "Notifying Redmine ..."
	RAILS_ENV=production rvm @{ruby.version} do bundle exec rake redmine:fetch_changesets
)
fi

