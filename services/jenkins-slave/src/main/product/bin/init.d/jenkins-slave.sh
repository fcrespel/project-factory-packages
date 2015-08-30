#!/bin/bash
#
# jenkins-slave  Startup script for Jenkins slave node
#
### BEGIN INIT INFO
# Provides: @{package.service}
# Required-Start: $local_fs $remote_fs $network
# Required-Stop: $local_fs $remote_fs $network
# Should-Start: $named $time
# Should-Stop: $named $time
# Default-Start: 3 4 5
# Default-Stop: 0 1 2 6
# Short-Description: @{product.name} Jenkins slave node
# Description: @{product.name} Jenkins slave node
### END INIT INFO

# Source LSB function library
if [ -r /lib/lsb/init-functions ]; then
	. /lib/lsb/init-functions
else
	exit 1
fi

# Default script variables
SLAVE_HOME="@{package.app}"
SLAVE_DATA="@{package.data}"
SLAVE_USER="@{package.user}"
SLAVE_LOG="@{package.log}/slave.log"
SLAVE_PIDFILE="$SLAVE_DATA/slave.pid"
SLAVE_LOCKFILE="$SLAVE_DATA/lockfile"

# Source service configuration
if [ -r "$SLAVE_HOME/service.conf" ] ; then
	. "$SLAVE_HOME/service.conf"
fi

# Local script variables
SERVICENAME="@{package.service}"
SLAVE_JAR="$SLAVE_HOME/slave.jar"
STARTTIMEOUT=10
if [ -x "/sbin/runuser" ]; then
	SU="/sbin/runuser -s /bin/sh"
else
	SU="/bin/su -s /bin/sh"
fi
if [ -n "$PROXY_HOST" -a -n "$PROXY_PORT" ]; then
	SLAVE_JAVA_OPTS="$SLAVE_JAVA_OPTS -Dhttp.proxyHost=$PROXY_HOST -Dhttp.proxyPort=$PROXY_PORT"
	SLAVE_JAVA_OPTS="$SLAVE_JAVA_OPTS -Dhttps.proxyHost=$PROXY_HOST -Dhttps.proxyPort=$PROXY_PORT"
fi
if [ -n "$NO_PROXY" ]; then
	SLAVE_JAVA_OPTS="$SLAVE_JAVA_OPTS -Dhttp.nonProxyHosts=$NO_PROXY"
fi

start() {
	echo -n $"Starting $SERVICENAME: "
	if [ -f "$SLAVE_LOCKFILE" ]; then
		if [ -f "$SLAVE_PIDFILE" ]; then
			read kpid < $SLAVE_PIDFILE
			if [ -d "/proc/${kpid}" ]; then
				log_success_msg
				RETVAL="0"
				return
			fi
		fi
	fi
	SLAVE_COMMAND="java $SLAVE_JAVA_OPTS -jar $SLAVE_JAR -jar-cache $SLAVE_DATA/cache/jars -jnlpUrl $JENKINS_MASTER_URL/computer/$SLAVE_NODENAME/slave-agent.jnlp"
	if [ -n "$SLAVE_SECRET" ]; then
		SLAVE_COMMAND="$SLAVE_COMMAND -secret $SLAVE_SECRET"
	fi
	$SU - $SLAVE_USER -c "$SLAVE_COMMAND" >> $SLAVE_LOG 2>&1 &
	RETVAL=$?
	if [ $RETVAL -eq 0 ]; then
		TIMEOUT="$STARTTIMEOUT"
		while [ $TIMEOUT -gt 0 ]; do
			kpid=`ps -fww -u $SLAVE_USER | grep "java.*-jar $SLAVE_JAR" | awk '{print $2}' | head -n 1`
			if [ -n "$kpid" ]; then
				echo "$kpid" > $SLAVE_PIDFILE
				break
			fi
			sleep 1
			let TIMEOUT=${TIMEOUT}-1
		done
		if [ $TIMEOUT -eq 0 ]; then
			echo "Timeout error occurred trying to start Jenkins slave."
			RETVAL=1
		fi
		if [ $RETVAL -eq 0 ]; then
			touch $SLAVE_LOCKFILE
			log_success_msg
		else
			log_failure_msg
		fi
	else
		log_failure_msg
	fi
	return $RETVAL
}

stop() {
	echo -n $"Stopping $SERVICENAME: "
	killproc -p $SLAVE_PIDFILE java
	RETVAL=$?
	if [ $RETVAL -eq 0 ]; then
		rm -f $SLAVE_LOCKFILE
		log_success_msg
	else
		log_failure_msg
	fi
	return $RETVAL
}

status() {
	kpid=`pidofproc -p $SLAVE_PIDFILE java`
	RETVAL=$?
	if [ $RETVAL -eq 0 ]; then
		log_success_msg $"$SERVICENAME (pid ${kpid}) is running..."
	elif [ $RETVAL -eq 1 ]; then
		log_failure_msg $"$SERVICENAME dead but pid file exists"
	elif [ $RETVAL -eq 4 ]; then
		log_failure_msg $"$SERVICENAME status unknown due to insufficient privileges."
	elif [ -f $SLAVE_LOCKFILE ]; then
		log_failure_msg $"$SERVICENAME dead but subsys locked"
		RETVAL=2
	else
		log_success_msg $"$SERVICENAME is stopped"
	fi
	return $RETVAL
}

configtest() {
	if [ -z "$JENKINS_MASTER_URL" ]; then
		log_failure_msg "$SERVICENAME config error: missing JENKINS_MASTER_URL value in service.conf"
		RETVAL=4
	elif [ -z "$SLAVE_NODENAME" ]; then
		log_failure_msg "$SERVICENAME config error: missing SLAVE_NODENAME value in service.conf"
		RETVAL=4
	elif [ -z "$SLAVE_SECRET" ]; then
		log_failure_msg "$SERVICENAME config error: missing SLAVE_SECRET value in service.conf"
		RETVAL=4
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
