#!/bin/bash
#
# httpd        Startup script for the Apache HTTP Server
#
### BEGIN INIT INFO
# Provides: @{package.service}
# Required-Start: $local_fs $remote_fs $network
# Required-Stop: $local_fs $remote_fs $network
# Should-Start: $named $time
# Should-Stop: $named $time
# Default-Start: 3 4 5
# Default-Stop: 0 1 2 6
# Short-Description: @{product.name} Apache HTTP Server
# Description: @{product.name} Apache HTTP Server
### END INIT INFO

# Source LSB function library
if [ -r /lib/lsb/init-functions ]; then
	. /lib/lsb/init-functions
else
	exit 1
fi

# Source service configuration
if [ -f "@{package.app}/conf/service.conf" ]; then
	. "@{package.app}/conf/service.conf"
fi

# Local script variables and default values
SERVICENAME="@{package.service}"
HTTPD=${HTTPD-/usr/sbin/httpd}
HTTPD_LANG=${HTTPD_LANG-"C"}
PIDFILE=${PIDFILE-/var/run/httpd/httpd.pid}
LOCKFILE=${LOCKFILE-/var/lock/subsys/httpd}
STATUSURL="http://localhost:$PORT/server-status"
STOPTIMEOUT="60"
if [ -x "/usr/bin/links" ]; then
	LYNX="/usr/bin/links -dump -width ${COLUMNS:-80}"
elif [ -x "/usr/bin/w3m" ]; then
	LYNX="/usr/bin/w3m -dump -cols ${COLUMNS:-80}"
elif [ -x "/usr/bin/lynx" ]; then
	LYNX="/usr/bin/lynx -dump -width=${COLUMNS:-80}"
fi

start() {
	echo -n $"Starting $SERVICENAME: "
	LANG=$HTTPD_LANG start_daemon -p $PIDFILE $HTTPD $OPTIONS
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
	kpid=`pidofproc -p $PIDFILE $HTTPD`
	killproc -p $PIDFILE $HTTPD
	RETVAL=$?
	if [ $RETVAL -eq 0 ]; then
		TIMEOUT="$STOPTIMEOUT"
		while [ $TIMEOUT -gt 0 ]; do
			kill -0 "$kpid" >/dev/null 2>&1 || break
			sleep 1
			let TIMEOUT=${TIMEOUT}-1
		done
		rm -f $LOCKFILE $PIDFILE
		log_success_msg
	else
		log_failure_msg
	fi
	return $RETVAL
}

reload() {
	echo -n $"Reloading $SERVICENAME: "
	if ! LANG=$HTTPD_LANG $HTTPD $OPTIONS -t >&/dev/null; then
		RETVAL=6
		log_failure_msg $"not reloading due to configuration syntax error"
	else
		killproc -p $PIDFILE $HTTPD -HUP
		RETVAL=$?
		if [ $RETVAL -eq 7 ]; then
			log_failure_msg $"$SERVICENAME shutdown"
		else
			log_success_msg
		fi
	fi
	return $RETVAL
}

status() {
	kpid=`pidofproc -p $PIDFILE $HTTPD`
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

fullstatus() {
	if [ -z "$LYNX" ]; then
		echo "The 'links', 'lynx' or 'w3m' package is required for this functionality."
	else
		$LYNX $STATUSURL
	fi
}

configtest() {
	LANG=$HTTPD_LANG $HTTPD $OPTIONS -t
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
	restart)
		stop
		start
		;;
	condrestart|try-restart)
		if status >&/dev/null; then
			stop
			start
		fi
		;;
	force-reload|reload)
		reload
		;;
	status)
		status
		;;
	fullstatus)
		fullstatus
		;;
	graceful|graceful-stop)
		LANG=$HTTPD_LANG $HTTPD $OPTIONS -k $1
		RETVAL=$?
		;;
	configtest)
		configtest
		;;
	*)
		echo $"Usage: $SERVICENAME {start|stop|restart|condrestart|try-restart|force-reload|reload|status|fullstatus|graceful|graceful-stop|configtest}"
		RETVAL=2
esac

exit $RETVAL
