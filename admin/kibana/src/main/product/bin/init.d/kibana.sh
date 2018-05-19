#!/bin/bash
#
# kibana       Startup script for Kibana
#
### BEGIN INIT INFO
# Provides: @{package.service}
# Required-Start: $local_fs $remote_fs $network
# Required-Stop: $local_fs $remote_fs $network
# Should-Start: $named $time
# Should-Stop: $named $time
# Default-Start: 3 4 5
# Default-Stop: 0 1 2 6
# Short-Description: @{product.name} Kibana daemon
# Description: @{product.name} Kibana daemon
### END INIT INFO

# Source LSB function library
if [ -r /lib/lsb/init-functions ]; then
	. /lib/lsb/init-functions
else
	exit 1
fi

# Local script variables
EXEC="@{package.app}/bin/kibana"
SERVICENAME="@{package.service}"
KIBANA_USER="@{package.user}"
CONFFILE="@{package.app}/config/kibana.yml"
LOGFILE="@{package.log}/kibana.log"
PIDFILE="@{package.app}/run/kibana.pid"
LOCKFILE="@{package.app}/run/lockfile"

start() {
	echo -n $"Starting $SERVICENAME: "
	start_daemon -u $KIBANA_USER -p $PIDFILE "$EXEC -c $CONFFILE >$LOGFILE 2>&1 &"
	RETVAL=$?
	if [ $RETVAL -eq 0 ]; then
		touch $LOCKFILE
		log_success_msg
	else
		log_failure_msg
	fi
	return $RETVAL
}

stop() {
	echo -n $"Stopping $SERVICENAME: "
	killproc -p $PIDFILE $EXEC
	RETVAL=$?
	if [ $RETVAL -eq 0 ]; then
		rm -f $LOCKFILE $PIDFILE
		log_success_msg
	else
		log_failure_msg
	fi
	return $RETVAL
}

restart() {
	stop
	start
}

status() {
	kpid=`pidofproc -p $PIDFILE $EXEC`
	RETVAL=$?
	if [ $RETVAL -eq 0 ]; then
		log_success_msg $"$SERVICENAME (pid ${kpid}) is running..."
	elif [ $RETVAL -eq 1 ]; then
		log_failure_msg $"$SERVICENAME dead but pid file exists"
	elif [ $RETVAL -eq 4 ]; then
		log_failure_msg $"$SERVICENAME status unknown due to insufficient privileges."
	elif [ -f $LOCKFILE ]; then
		log_failure_msg $"$SERVICENAME dead but subsys locked"
		RETVAL=2
	else
		log_success_msg $"$SERVICENAME is stopped"
	fi
	return $RETVAL
}

status_q() {
	status >/dev/null 2>&1
}

# See how we were called
case "$1" in
	start)
		status_q && exit 0
		start
		;;
	stop)
		status_q || exit 0
		stop
		;;
	status)
		status
		;;
	restart|force-reload)
		restart
		;;
	condrestart|try-restart)
		status_q || exit 0
		restart
		;;
	reload)
		status_q || exit 7
		restart
		;;
	*)
		echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload}"
		exit 2
esac
exit $?
