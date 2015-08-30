#!/bin/bash
#
# actievmq     Startup script for the ActiveMQ message broker
#
### BEGIN INIT INFO
# Provides: @{package.service}
# Required-Start: $local_fs $remote_fs $network
# Required-Stop: $local_fs $remote_fs $network
# Should-Start: $named $time
# Should-Stop: $named $time
# Default-Start: 3 4 5
# Default-Stop: 0 1 2 6
# Short-Description: @{product.name} ActiveMQ message broker
# Description: @{product.name} ActiveMQ message broker
### END INIT INFO

# Source LSB function library
if [ -r /lib/lsb/init-functions ]; then
	. /lib/lsb/init-functions
else
	exit 1
fi

# Default script variables
ACTIVEMQ_HOME="@{package.app}"
ACTIVEMQ_USER="@{package.user}"
ACTIVEMQ_OPTS_MEMORY="@{package.java.opts}"
ACTIVEMQ_PORT_HTTP="@{activemq.port.http}"
ACTIVEMQ_INITLOG="@{package.log}/initd.log"
ACTIVEMQ_PIDFILE="@{package.data}/activemq.pid"
ACTIVEMQ_LOCKFILE="@{package.data}/lockfile"

# Source service configuration
if [ -r "@{package.app}/conf/service.conf" ] ; then
	. "@{package.app}/conf/service.conf"
fi

# Local script variables
SERVICENAME="@{package.service}"
ACTIVEMQ_SCRIPT="$ACTIVEMQ_HOME/bin/activemq"

call_activemq() {
	ACTIVEMQ_HOME="$ACTIVEMQ_HOME" \
	ACTIVEMQ_USER="-s /bin/sh $ACTIVEMQ_USER" \
	ACTIVEMQ_PIDFILE="$ACTIVEMQ_PIDFILE" \
	ACTIVEMQ_OPTS_MEMORY="$ACTIVEMQ_OPTS_MEMORY -Djetty.port=$ACTIVEMQ_PORT_HTTP" \
	$ACTIVEMQ_SCRIPT "$@" >> $ACTIVEMQ_INITLOG 2>&1
}

start() {
	echo -n $"Starting $SERVICENAME: "
	call_activemq start
	RETVAL=$?
	if [ $RETVAL -eq 0 ]; then
		touch $ACTIVEMQ_LOCKFILE
		log_success_msg
	else
		log_failure_msg
	fi
	return $RETVAL
}

stop() {
	echo -n $"Stopping $SERVICENAME: "
	call_activemq stop
	RETVAL=$?
	if [ $RETVAL -eq 0 ]; then
		rm -f $ACTIVEMQ_LOCKFILE
		log_success_msg
	else
		log_failure_msg
	fi
	return $RETVAL
}

status() {
	call_activemq status
	RETVAL=$?
	if [ $RETVAL -eq 0 ]; then
		kpid=`cat "$ACTIVEMQ_PIDFILE"`
		log_success_msg $"$SERVICENAME (pid ${kpid}) is running..."
	elif [ $RETVAL -eq 1 ]; then
		if [ -f "$ACTIVEMQ_PIDFILE" ]; then
			log_failure_msg $"$SERVICENAME dead but pid file exists"
		else
			RETVAL=3
			log_success_msg $"$SERVICENAME is stopped"
		fi
	elif [ -f "$ACTIVEMQ_LOCKFILE" ]; then
		log_failure_msg $"$SERVICENAME dead but subsys locked"
		RETVAL=2
	fi
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
		RETVAL=3
		;;
	*)
		echo $"Usage: $0 {start|stop|status|restart|force-reload|condrestart|try-restart|reload}"
		RETVAL=2
esac

exit $RETVAL
