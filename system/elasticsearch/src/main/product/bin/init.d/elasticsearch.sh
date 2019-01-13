#!/bin/bash
#
# elasticsearch	Startup script for the Elasticsearch daemon
#
### BEGIN INIT INFO
# Provides: @{package.service}
# Required-Start: $local_fs $remote_fs $network
# Required-Stop: $local_fs $remote_fs $network
# Should-Start: $named $time
# Should-Stop: $named $time
# Default-Start: 3 4 5
# Default-Stop: 0 1 2 6
# Short-Description: @{product.name} Elasticsearch daemon
# Description: @{product.name} Elasticsearch daemon
### END INIT INFO

# Source LSB function library
if [ -r /lib/lsb/init-functions ]; then
	. /lib/lsb/init-functions
else
	exit 1
fi

# Default values
ES_USER="@{package.user}"
ES_GROUP="@{package.group}"
ES_HOME="@{package.app}"
MAX_OPEN_FILES=65536
MAX_MAP_COUNT=262144
ES_PATH_CONF="$ES_HOME/config"
PID_DIR="$ES_HOME/run"

# Source service configuration
ES_ENV_FILE="$CONF_DIR/service.conf"
if [ -f "$ES_ENV_FILE" ]; then
	. "$ES_ENV_FILE"
fi

# Local script variables
EXEC="$ES_HOME/bin/elasticsearch"
SERVICENAME="@{package.service}"
PIDFILE="$PID_DIR/elasticsearch.pid"
LOCKFILE="$PID_DIR/lockfile"

export ES_JAVA_OPTS
export JAVA_HOME
export ES_PATH_CONF
export ES_STARTUP_SLEEP_TIME

checkJava() {
	if [ -x "$JAVA_HOME/bin/java" ]; then
		JAVA="$JAVA_HOME/bin/java"
	else
		JAVA=`which java`
	fi

	if [ ! -x "$JAVA" ]; then
		echo "Could not find any executable java binary. Please install java in your PATH or set JAVA_HOME"
		exit 1
	fi
}

start() {
	checkJava
	[ -x $EXEC ] || exit 5
	if [ -n "$MAX_OPEN_FILES" ]; then
		ulimit -n $MAX_OPEN_FILES
	fi
	if [ -n "$MAX_LOCKED_MEMORY" ]; then
		ulimit -l $MAX_LOCKED_MEMORY
	fi
	if [ -n "$MAX_MAP_COUNT" -a -f /proc/sys/vm/max_map_count -a "$MAX_MAP_COUNT" -gt $(cat /proc/sys/vm/max_map_count) ]; then
		sysctl -q -w vm.max_map_count=$MAX_MAP_COUNT
	fi

	# Ensure that the PID_DIR exists (it is cleaned at OS startup time)
	if [ -n "$PID_DIR" ] && [ ! -e "$PID_DIR" ]; then
		mkdir -p "$PID_DIR" && chown "$ES_USER":"$ES_GROUP" "$PID_DIR"
	fi
	if [ -n "$PIDFILE" ] && [ ! -e "$PIDFILE" ]; then
		touch "$PIDFILE" && chown "$ES_USER":"$ES_GROUP" "$PIDFILE"
	fi

	cd $ES_HOME
	echo -n $"Starting $SERVICENAME: "
	start_daemon -u $ES_USER -p $PIDFILE $EXEC -p $PIDFILE -d
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
	restart)
		restart
		;;
	reload)
		status_q || exit 7
		restart
		;;
	force-reload)
		restart
		;;
	status)
		status
		;;
	condrestart|try-restart)
		status_q || exit 0
		restart
		;;
	*)
		echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload}"
		exit 2
esac
exit $?