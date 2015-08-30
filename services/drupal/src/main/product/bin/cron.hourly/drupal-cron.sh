#!/bin/bash
#
# Drupal cron exec script.
# By Fabien CRESPEL <fabien@crespel.net>
#

. "@{product.bin}/loadenv.sh"

DRUPAL_DIR="@{package.app}"
LOG_FILE="@{package.log}/cron.log"
DATE=`date --rfc-3339=seconds`

if [ -e "$DRUPAL_DIR" ]; then
	echo "[$DATE]" >> "$LOG_FILE"
	drush core-cron >> "$LOG_FILE" 2>&1
	echo >> "$LOG_FILE"
fi
