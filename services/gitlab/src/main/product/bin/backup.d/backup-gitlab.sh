#!/bin/bash
#
# GitLab Backup script.
# By Fabien CRESPEL <fabien@crespel.net>
#

. "@{product.bin}/loadenv.sh"

GITLAB_DIR="@{package.app}"
LOG_FILE="$GITLAB_DIR/log/backup.log"
DATE=`date --rfc-3339=seconds`

if [ -e "$GITLAB_DIR" ]; then
(
	cd "$GITLAB_DIR"
	echo "[$DATE]" >> "$LOG_FILE"
	rvm default do bundle exec rake gitlab:backup:create RAILS_ENV=production >> "$LOG_FILE" 2>&1
	echo >> "$LOG_FILE"
)
fi
