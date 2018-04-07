#!/bin/bash
#
# mysql 	   Startup script for the MySQL database server
#
### BEGIN INIT INFO
# Provides: @{package.service}
# Required-Start: $local_fs $remote_fs $network
# Required-Stop: $local_fs $remote_fs $network
# Should-Start: $named $time
# Should-Stop: $named $time
# Default-Start: 3 4 5
# Default-Stop: 0 1 2 6
# Short-Description: @{product.name} MySQL database server
# Description: @{product.name} MySQL database server
### END INIT INFO

# Source LSB function library
if [ -r /lib/lsb/init-functions ]; then
	. /lib/lsb/init-functions
else
	exit 1
fi

# Extract value of a MySQL option from config files
# Usage: get_mysql_option SECTION VARNAME DEFAULT
get_mysql_option(){
	result=`$MY_PRINT_DEFAULTS --defaults-file="$CONFIGFILE" "$1" | sed -n "s/^--$2=//p" | tail -n 1`
	if [ -z "$result" ]; then
		echo "$3"
	else
		echo "$result"
	fi
}

# Local script variables and default values
SERVICENAME="@{package.service}"
BASEDIR="@{system.mysql.app}"
MYSQLD="@{package.app}/bin/mysqld_safe"
MYSQLADMIN="@{system.mysql.bin}/mysqladmin"
MY_PRINT_DEFAULTS="@{system.mysql.bin}/my_print_defaults"
MYSQL_INSTALL_DB="@{system.mysql.bin}/mysql_install_db"
CONFIGFILE="@{package.app}/conf/my.cnf"
LOCKFILE="@{package.app}/run/lockfile"
DATADIR=`get_mysql_option mysqld datadir "@{package.data}"`
SOCKETFILE=`get_mysql_option mysqld socket "$DATADIR/mysql.sock"`
ERRLOGFILE=`get_mysql_option mysqld_safe log-error "@{package.log}/mysqld.log"`
PIDFILE=`get_mysql_option mysqld_safe pid-file "@{package.app}/run/mysqld.pid"`
MYUSER=`get_mysql_option mysqld_safe user "@{package.user}"`
MYGROUP=`id -g $MYUSER`
STARTTIMEOUT=120
STOPTIMEOUT=60

start() {
	[ -x $MYSQLD ] || exit 5
	# check to see if it's already running
	RESPONSE=`$MYSQLADMIN --socket="$SOCKETFILE" --user=UNKNOWN_MYSQL_USER ping 2>&1`
	if [ $? = 0 ]; then
		# already running, do nothing
		log_success_msg $"Starting $SERVICENAME: "
		RETVAL=0
	elif echo "$RESPONSE" | grep -q "Access denied for user"; then
		# already running, do nothing
		log_success_msg $"Starting $SERVICENAME: "
		RETVAL=0
	else
		# prepare for start
		touch "$ERRLOGFILE"
		chown $MYUSER:$MYGROUP "$ERRLOGFILE" 
		chmod 0640 "$ERRLOGFILE"
		[ -x /sbin/restorecon ] && /sbin/restorecon "$ERRLOGFILE"
		if [ ! -d "$DATADIR/mysql" ] ; then
			# First, make sure $DATADIR is there with correct permissions
			if [ ! -e "$DATADIR" -a ! -h "$DATADIR" ]; then
				mkdir -p "$DATADIR" || exit 1
			fi
			chown $MYUSER:$MYGROUP "$DATADIR"
			chmod 0755 "$DATADIR"
			[ -x /sbin/restorecon ] && /sbin/restorecon "$DATADIR"
			# Now create the database
			echo -n $"Initializing MySQL database: "
			$MYSQL_INSTALL_DB --datadir="$DATADIR" --user=$MYUSER
			RETVAL=$?
			if [ $RETVAL -ne 0 ] ; then
				log_failure_msg
				return $RETVAL
			else
				log_success_msg
				chown -R $MYUSER:$MYGROUP "$DATADIR"
			fi
		fi
		chown $MYUSER:$MYGROUP "$DATADIR"
		chmod 0755 "$DATADIR"
		# Pass all the options determined above, to ensure consistent behavior.
		# In many cases mysqld_safe would arrive at the same conclusions anyway
		# but we need to be sure.  (An exception is that we don't force the
		# log-error setting, since this script doesn't really depend on that,
		# and some users might prefer to configure logging to syslog.)
		# Note: set --basedir to prevent probes that might trigger SELinux
		# alarms, per bug #547485
		$MYSQLD --defaults-file="$CONFIGFILE" --datadir="$DATADIR" \
			--socket="$SOCKETFILE" --pid-file="$PIDFILE" \
			--basedir="$BASEDIR" --user=$MYUSER >/dev/null 2>&1 &
		MYSQLPID=$!
		# Spin for a maximum of N seconds waiting for the server to come up;
		# exit the loop immediately if mysqld_safe process disappears.
		# Rather than assuming we know a valid username, accept an "access
		# denied" response as meaning the server is functioning.
		RETVAL=0
		TIMEOUT="$STARTTIMEOUT"
		while [ $TIMEOUT -gt 0 ]; do
			RESPONSE=`$MYSQLADMIN --socket="$SOCKETFILE" --user=UNKNOWN_MYSQL_USER ping 2>&1` && break
			echo "$RESPONSE" | grep -q "Access denied for user" && break
			if ! /bin/kill -0 $MYSQLPID 2>/dev/null; then
				echo "MySQL Daemon failed to start."
				RETVAL=1
				break
			fi
			sleep 1
			let TIMEOUT=${TIMEOUT}-1
		done
		if [ $TIMEOUT -eq 0 ]; then
			echo "Timeout error occurred trying to start MySQL Daemon."
			RETVAL=1
		fi
		if [ $RETVAL -eq 0 ]; then
			log_success_msg $"Starting $SERVICENAME: "
			touch "$LOCKFILE"
		else
			log_failure_msg $"Starting $SERVICENAME: "
		fi
	fi
	return $RETVAL
}

stop() {
	if [ ! -f "$PIDFILE" ]; then
		# not running; per LSB standards this is "ok"
		log_success_msg $"Stopping $SERVICENAME: "
		RETVAL=0
	else
		MYSQLPID=`cat "$PIDFILE"`
		if [ -n "$MYSQLPID" ]; then
			/bin/kill "$MYSQLPID" >/dev/null 2>&1
			RETVAL=$?
			if [ $RETVAL -eq 0 ]; then
				TIMEOUT="$STOPTIMEOUT"
				while [ $TIMEOUT -gt 0 ]; do
					/bin/kill -0 "$MYSQLPID" >/dev/null 2>&1 || break
					sleep 1
					let TIMEOUT=${TIMEOUT}-1
				done
				if [ $TIMEOUT -eq 0 ]; then
					echo "Timeout error occurred trying to stop MySQL Daemon."
					RETVAL=1
					log_failure_msg $"Stopping $SERVICENAME: "
				else
					rm -f "$LOCKFILE" "$SOCKETFILE"
					log_success_msg $"Stopping $SERVICENAME: "
				fi
			else
				log_failure_msg $"Stopping $SERVICENAME: "
			fi
		else
			# failed to read pidfile, probably insufficient permissions
			log_failure_msg $"Stopping $SERVICENAME: "
			RETVAL=4
		fi
	fi
	return $RETVAL
}
 
restart() {
	stop
	start
}

condrestart() {
	[ -e "$LOCKFILE" ] && restart || :
}

status() {
	MYSQLPID=`pidofproc -p "$PIDFILE" mysqld`
	RETVAL=$?
	if [ $RETVAL -eq 0 ]; then
		log_success_msg $"$SERVICENAME (pid ${MYSQLPID}) is running..."
	elif [ $RETVAL -eq 1 ]; then
		log_failure_msg $"$SERVICENAME dead but pid file exists"
	elif [ $RETVAL -eq 4 ]; then
		log_failure_msg $"$SERVICENAME status unknown due to insufficient privileges."
	elif [ -f "$LOCKFILE" ]; then
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
		restart
		;;
	condrestart|try-restart)
		condrestart
		;;
	reload)
		RETVAL=3
		;;
	*)
		echo $"Usage: $0 {start|stop|status|restart|force-reload|condrestart|try-restart|reload}"
		RETVAL=2
esac

exit $RETVAL
