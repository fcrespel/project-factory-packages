#!/bin/bash
#
# nagios       Startup script for the Nagios monitoring system
#
### BEGIN INIT INFO
# Provides: @{package.service}
# Required-Start: $local_fs $remote_fs $network
# Required-Stop: $local_fs $remote_fs $network
# Should-Start: $named $time
# Should-Stop: $named $time
# Default-Start: 3 4 5
# Default-Stop: 0 1 2 6
# Short-Description: @{product.name} Nagios monitoring system
# Description: @{product.name} Nagios monitoring system
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

# Local script variables
SERVICENAME="@{package.service}"
NAGIOS_BIN="@{system.nagios.bin.nagios}"
NAGIOS_CFG_FILE="@{package.app}/conf/nagios.cfg"
NAGIOS_STATUS_FILE="@{package.data}/var/status.dat"
NAGIOS_RETENTION_FILE="@{package.data}/var/retention.dat"
NAGIOS_COMMAND_FILE="@{package.data}/cmd/nagios.cmd"
NAGIOS_LOG_FILE="@{package.log}/nagios.log"
NAGIOS_PID_FILE="@{package.app}/run/nagios.pid"
NAGIOS_LOCK_FILE="@{package.app}/run/lockfile"
NAGIOS_USER="@{package.user}"
NAGIOS_GROUP="@{package.group}"
STOPTIMEOUT="10"

start() {
	echo -n "Starting $SERVICENAME: "
	touch $NAGIOS_LOG_FILE $NAGIOS_STATUS_FILE $NAGIOS_RETENTION_FILE $NAGIOS_PID_FILE
	chown $NAGIOS_USER:$NAGIOS_GROUP $NAGIOS_LOG_FILE $NAGIOS_STATUS_FILE $NAGIOS_RETENTION_FILE $NAGIOS_PID_FILE
	rm -f $NAGIOS_COMMAND_FILE
	[ -x /sbin/restorecon ] && /sbin/restorecon $NAGIOS_PID_FILE
	start_daemon -p $NAGIOS_PID_FILE $NAGIOS_BIN -d $NAGIOS_CFG_FILE
	RETVAL=$?
	if [ $RETVAL -eq 0 ]; then
		touch $NAGIOS_LOCK_FILE
		log_success_msg
	else
		log_failure_msg
	fi
	return $RETVAL
}

stop() {
	echo -n "Stopping $SERVICENAME: "
	killproc -p $NAGIOS_PID_FILE $NAGIOS_BIN
	RETVAL=$?
	if [ $RETVAL -eq 0 ]; then
		TIMEOUT="$STOPTIMEOUT"
		while [ $TIMEOUT -gt 0 ]; do
			status >/dev/null 2>&1 || break
			sleep 1
			let TIMEOUT=${TIMEOUT}-1
		done
		if status >/dev/null 2>&1; then
			log_warning_msg "$SERVICENAME did not exit in a timely manner"
		else
			log_success_msg
		fi
		rm -f $NAGIOS_STATUS_FILE $NAGIOS_PID_FILE $NAGIOS_LOCK_FILE $NAGIOS_COMMAND_FILE
	else
		log_failure_msg
	fi
	return $RETVAL
}

reload() {
	if [ ! -f $NAGIOS_PID_FILE ]; then
		start
	else
		if status >/dev/null 2>&1; then
			echo -n "Reloading $SERVICENAME configuration... "
			killproc -p $NAGIOS_PID_FILE $NAGIOS_BIN -HUP
			log_success_msg
		else
			stop
			start
		fi
	fi
}

status() {
	kpid=`pidofproc -p $NAGIOS_PID_FILE $NAGIOS_BIN`
	RETVAL=$?
	if [ $RETVAL -eq 0 ]; then
		log_success_msg $"$SERVICENAME (pid ${kpid}) is running..."
	elif [ $RETVAL -eq 1 ]; then
		log_failure_msg $"$SERVICENAME dead but pid file exists"
	elif [ $RETVAL -eq 4 ]; then
		log_failure_msg $"$SERVICENAME status unknown due to insufficient privileges."
	elif [ -f $NAGIOS_LOCK_FILE ]; then
		log_failure_msg $"$SERVICENAME dead but subsys locked"
		RETVAL=2
	else
		log_success_msg $"$SERVICENAME is stopped"
	fi
	return $RETVAL
}

configtest() {
	echo -n "Running $SERVICENAME configuration check... "
	if [ ! -f $NAGIOS_BIN ]; then
		log_failure_msg "Executable file $NAGIOS_BIN not found."
		RETVAL=1
	elif [ ! -f $NAGIOS_CFG_FILE ]; then
		log_failure_msg "Configuration file $NAGIOS_CFG_FILE not found."
		RETVAL=1
	else
		$NAGIOS_BIN -v $NAGIOS_CFG_FILE > /dev/null 2>&1
		if [ $? -eq 0 ]; then
			log_success_msg
			RETVAL=0
		else
			log_failure_msg "CONFIG ERROR! Check your Nagios configuration."
			RETVAL=1
		fi
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
	checkconfig|configtest)
		configtest
		;;
	restart)
		if configtest; then
			stop
			start
		fi
		;;
	reload|force-reload)
		if configtest; then
			reload
		fi
		;;
	*)
		echo "Usage: $SERVICENAME {start|stop|restart|reload|force-reload|status|checkconfig|configtest}"
		RETVAL=2
esac

exit $RETVAL
