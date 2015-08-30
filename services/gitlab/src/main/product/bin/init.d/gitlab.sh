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
# Short-Description: @{product.name} GitLab sidekiq daemon
# Description: @{product.name} GitLab sidekiq daemon
### END INIT INFO

# Source LSB function library
if [ -r /lib/lsb/init-functions ]; then
	. /lib/lsb/init-functions
else
	exit 1
fi

# Local script variables
SERVICENAME="@{package.service}"
PROGNAME="sidekiq"
EXEC="@{package.app}/bin/background_jobs"
PIDFILE="@{package.app}/tmp/pids/sidekiq.pid"
LOCKFILE="@{package.app}/tmp/pids/lockfile"
GITLABUSER="@{package.user}"

# For SELinux we need to use 'runuser' not 'su'
if [ -x "/sbin/runuser" ]; then
	SU="/sbin/runuser -s /bin/bash"
else
	SU="/bin/su -s /bin/bash"
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
	$SU - $GITLABUSER -c "$EXEC start"
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
	killproc -p $PIDFILE $PROGNAME
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
	kpid=`pidofproc -p $PIDFILE $PROGNAME`
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
