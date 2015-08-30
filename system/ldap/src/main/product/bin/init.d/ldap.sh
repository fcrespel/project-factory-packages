#!/bin/bash
#
# ldap         Startup script for the OpenLDAP directory server
#
### BEGIN INIT INFO
# Provides: @{package.service}
# Required-Start: $local_fs $remote_fs $network
# Required-Stop: $local_fs $remote_fs $network
# Should-Start: $named $time
# Should-Stop: $named $time
# Default-Start: 3 4 5
# Default-Stop: 0 1 2 6
# Short-Description: @{product.name} OpenLDAP directory server
# Description: @{product.name} OpenLDAP directory server
### END INIT INFO

# Source LSB function library
if [ -r /lib/lsb/init-functions ]; then
	. /lib/lsb/init-functions
else
	exit 1
fi

# Source service configuration
if [ -r "@{package.app}/conf/service.conf" ] ; then
	. "@{package.app}/conf/service.conf"
fi

# Local script variables
SERVICENAME="@{package.service}"
SLAPD="@{system.openldap.bin.slapd}"
SLAPTEST="@{system.openldap.bin.slaptest}"
LOCKFILE="@{package.app}/run/lockfile"
CONFIGDIR="@{package.app}/conf.d"
PIDFILE="@{package.app}/run/slapd.pid"
LDAPUSER="@{package.user}"

start() {
	echo -n $"Starting $SERVICENAME: "
	start_daemon -p $PIDFILE $SLAPD -h "$SLAPD_URLS" -u $LDAPUSER $SLAPD_OPTIONS
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
	killproc -p $PIDFILE $SLAPD
	RETVAL=$?
	if [ $RETVAL -eq 0 ]; then
		rm -f $LOCKFILE $PIDFILE
		log_success_msg
	else
		log_failure_msg
	fi
	return $RETVAL
}

status() {
	kpid=`pidofproc -p $PIDFILE $SLAPD`
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

configtest() {
	slaptestout=`$SLAPTEST -u -F "$CONFIGDIR" 2>&1`
	slaptestexit=$?
	if [ $slaptestexit -eq 0 ]; then
		if echo "$slaptestout" | grep -v "config file testing succeeded" >/dev/null ; then
			log_warning_msg $"Checking configuration files for $SERVICENAME: "
			echo "$slaptestout"
		fi
		RETVAL=0
	else
		log_failure_msg $"Checking configuration files for $SERVICENAME: "
		echo "$slaptestout"
		RETVAL=6
	fi
	return $RETVAL
}

# See how we were called
RETVAL=0
case "$1" in
	start)
		if configtest; then
			start
		fi
		;;
	stop)
		stop
		;;
	status)
		status
		;;
	restart|force-reload)
		if configtest; then
			stop
			start
		fi
		;;
	condrestart|try-restart)
		if configtest && status >/dev/null 2>&1; then
			stop
			start
		fi
		;;
	reload)
		RETVAL=3
		;;
	configtest)
		configtest
		;;
	*)
		echo $"Usage: $0 {start|stop|status|restart|force-reload|condrestart|try-restart|reload|configtest}"
		RETVAL=2
esac

exit $RETVAL
