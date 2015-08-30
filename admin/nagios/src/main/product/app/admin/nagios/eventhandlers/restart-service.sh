#!/bin/sh
#
# Event handler script for restarting a service on the local machine.
# By Fabien CRESPEL <fabien@crespel.net>
#
# See:  http://nagios.sourceforge.net/docs/3_0/eventhandlers.html
# Note: This script will only restart the service if the service is
#       retried 3 times (in a "soft" state) or if the service somehow
#       manages to fall into a "hard" error state.
#

# Check syntax
if [ $# -lt 4 ]; then
	echo "Syntax: $0 <service state> <service state type> <attempt number> <service name>"
	exit 1
fi

# Script variables
SERVICESTATE="$1"
SERVICESTATETYPE="$2"
SERVICEATTEMPT="$3"
SERVICENAME="$4"
SERVICESCRIPT="@{system.init}/$SERVICENAME"
SERVICEALLOWED="@{product.id}-*"

# Check if service is allowed
if [[ ! "$SERVICENAME" == $SERVICEALLOWED ]]; then
	echo "Service $SERVICENAME is not allowed to be restarted via this script"
	exit 1
fi

# Check if service exists and is executable
if [ ! -x "$SERVICESCRIPT" ]; then
	echo "Service $SERVICENAME does not exist"
	exit 1
fi

# What state is the service in?
case "$SERVICESTATE" in
OK)
	# The service just came back up, so don't do anything...
	;;
WARNING)
	# We don't really care about warning states, since the service is probably still running...
	;;
UNKNOWN)
	# We don't know what might be causing an unknown error, so don't do anything...
	;;
CRITICAL)
	# Aha!  The service appears to have a problem - perhaps we should restart it...

	# Is this a "soft" or a "hard" state?
	case "$SERVICESTATETYPE" in

	# We're in a "soft" state, meaning that Nagios is in the middle of retrying the
	# check before it turns into a "hard" state and contacts get notified...
	SOFT)

		# What check attempt are we on?  We don't want to restart the service on the first
		# check, because it may just be a fluke!
		case "$SERVICEATTEMPT" in

		# Wait until the check has been tried 3 times before restarting the service.
		# If the check fails on the 4th time (after we restart the service), the state
		# type will turn to "hard" and contacts will be notified of the problem.
		# Hopefully this will restart the service successfully, so the 4th check will
		# result in a "soft" recovery.  If that happens no one gets notified because we
		# fixed the problem!
		3)
			echo "Restarting service $SERVICENAME (3rd soft critical state)..."
			$SERVICESCRIPT restart
			;;
		esac
		;;

	# The service somehow managed to turn into a hard error without getting fixed.
	# It should have been restarted by the code above, but for some reason it didn't.
	# Let's give it one last try, shall we?  
	# Note: Contacts have already been notified of a problem with the service at this
	# point (unless you disabled notifications for this service)
	HARD)
		echo "Restarting service $SERVICENAME ..."
		$SERVICESCRIPT restart
		;;
	esac
	;;
esac

exit 0
