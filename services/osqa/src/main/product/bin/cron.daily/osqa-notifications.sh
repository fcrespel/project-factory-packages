#!/bin/bash
#
# OSQA email notifications exec script.
# By Fabien CRESPEL <fabien@crespel.net>
#

PYTHON="/usr/bin/python"
PYTHONPATH="@{product.app}/services"
export PYTHONPATH

OSQA_DIR="@{package.app}"
LOG_FILE="@{package.log}/send_email_alerts.log"
DATE=`date --rfc-3339=seconds`

if [ -e "$OSQA_DIR/manage.py" ]; then
	echo "[$DATE]" >> "$LOG_FILE"
	$PYTHON "$OSQA_DIR/manage.py" send_email_alerts >> "$LOG_FILE" 2>&1
	echo >> "$LOG_FILE"
fi
