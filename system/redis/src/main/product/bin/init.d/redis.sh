#/bin/bash
#
# redis        Startup script for the Redis key-value cache and store
#
### BEGIN INIT INFO
# Provides: @{package.service}
# Required-Start: $local_fs $remote_fs $network
# Required-Stop: $local_fs $remote_fs $network
# Should-Start: $syslog $named
# Should-Stop: $syslog $named
# Default-Start: 3 4 5
# Default-Stop: 0 1 2 6
# Short-Description: @{product.name} Redis daemon
# Description: @{product.name} Redis daemon
### END INIT INFO

# Source LSB function library
if [ -r /lib/lsb/init-functions ]; then
	. /lib/lsb/init-functions
else
	exit 1
fi

# Local script variables
SERVICENAME="@{package.service}"
EXEC="@{package.app}/bin/redis-server"
PIDFILE="@{package.app}/run/redis.pid"
LOCKFILE="@{package.app}/run/lockfile"
CONF="@{package.app}/conf/redis.conf"
REDISUSER="@{package.user}"
REDISPORT="@{redis.port}"

# For SELinux we need to use 'runuser' not 'su'
if [ -x "/sbin/runuser" ]; then
	SU="/sbin/runuser -s /bin/sh"
else
	SU="/bin/su -s /bin/sh"
fi

start() {
	echo -n $"Starting $SERVICENAME: "
	if [ -f "$LOCKFILE" ]; then
		if [ -f "$PIDFILE" ]; then
			read kpid < "$PIDFILE"
			if [ -d "/proc/${kpid}" ]; then
				log_success_msg
				RETVAL=0
				return $RETVAL
			fi
		fi
	fi
	$SU - $REDISUSER -c "$EXEC $CONF"
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
		;;
esac

exit $RETVAL
