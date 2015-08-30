#!/bin/bash
#
# Project Factory - Nagios Functions
# By Fabien CRESPEL <fabien@crespel.net>
#

# Execute an arbitrary Nagios command
function nagios_exec
{
	if [ -z "$NAGIOS_CMD" ]; then
		printerror "ERROR: Nagios command file path is not defined or is empty"
		return 1
	fi
	if [ ! -e "$NAGIOS_CMD" ]; then
		return 0
	fi
	
	local CMD="$1"
	if [ -z "$CMD" ]; then
		printerror "ERROR: missing Nagios command argument"
		return 2
	fi
	shift
	
	local TIMESTAMP=`date +%s`
	local CMDLINE="[$TIMESTAMP] $CMD"
	while [ $# -gt 0 ]; do
		CMDLINE="$CMDLINE;$1"
		shift
	done
	
	echo "$CMDLINE" > "$NAGIOS_CMD"
}

# Disable active checks for a service
function nagios_disable_service
{
	local SERVICE="$1"
	nagios_exec DISABLE_SVC_CHECK "$PRODUCT_DOMAIN" "$SERVICE"
}

# Enable active checks for a service
function nagios_enable_service
{
	local SERVICE="$1"
	nagios_exec ENABLE_SVC_CHECK "$PRODUCT_DOMAIN" "$SERVICE"
}
