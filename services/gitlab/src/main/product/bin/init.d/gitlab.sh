#/bin/bash
#
# gitlab       Startup script for the GitLab repository manager
#
### BEGIN INIT INFO
# Provides: @{package.service}
# Required-Start: $local_fs $remote_fs $network @{product.id}-redis
# Required-Stop: $local_fs $remote_fs $network @{product.id}-redis
# Should-Start: $syslog $named
# Should-Stop: $syslog $named
# Default-Start: 3 4 5
# Default-Stop: 0 1 2 6
# Short-Description: @{product.name} GitLab repository management
# Description: @{product.name} GitLab repository management
### END INIT INFO

# Source LSB function library
if [ -r /lib/lsb/init-functions ]; then
	. /lib/lsb/init-functions
else
	exit 1
fi

# Source service configuration
if [ -f "@{package.app}/config/service.conf" ]; then
	. "@{package.app}/config/service.conf"
fi

# For SELinux we need to use 'runuser' not 'su'
if [ -x "/sbin/runuser" ]; then
	SU="/sbin/runuser -s /bin/bash"
else
	SU="/bin/su -s /bin/bash"
fi

# Local script variables
SERVICENAME="@{package.service}"
EXEC="$app_root/lib/support/init.d/gitlab"
INITLOG="$app_root/log/initd.log"

start() {
	echo -n $"Starting $SERVICENAME: "
	$SU - $app_user -c "$EXEC start" >> "$INITLOG" 2>&1
	RETVAL=$?
	if [ $RETVAL -eq 0 ]; then
		log_success_msg
	else
		log_failure_msg
	fi
	return $RETVAL
}

stop() {
	echo -n $"Stopping $SERVICENAME: "
	$SU - $app_user -c "$EXEC stop" >> "$INITLOG" 2>&1
	RETVAL=$?
	if [ $RETVAL -eq 0 ]; then
		log_success_msg
	else
		log_failure_msg
	fi
	return $RETVAL
}

reload() {
	echo -n $"Reloading $SERVICENAME: "
	$SU - $app_user -c "$EXEC reload" >> "$INITLOG" 2>&1
	RETVAL=$?
	if [ $RETVAL -eq 0 ]; then
		log_success_msg
	else
		log_failure_msg
	fi
	return $RETVAL
}

status() {
	$SU - $app_user -c "$EXEC status"
	RETVAL=$?
	return $RETVAL
}

# See how we were called
RETVAL=0
case "$1" in
	start)
		start
		;;
	stop)
		stop
		;;
	status)
		status
		;;
	restart|force-reload)
		stop
		start
		;;
	condrestart|try-restart)
		if status >/dev/null 2>&1; then
			stop
			start
		fi
		;;
	reload)
		reload
		;;
	*)
		echo $"Usage: $0 {start|stop|status|restart|force-reload|condrestart|try-restart|reload}"
		RETVAL=2
		;;
esac

exit $RETVAL
