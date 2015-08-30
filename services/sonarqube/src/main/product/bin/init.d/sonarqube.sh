#!/bin/bash
#
# sonarqube    Startup script for the SonarQube server
#
### BEGIN INIT INFO
# Provides: @{package.service}
# Required-Start: $local_fs $remote_fs $network
# Required-Stop: $local_fs $remote_fs $network
# Should-Start: $named $time
# Should-Stop: $named $time
# Default-Start: 3 4 5
# Default-Stop: 0 1 2 6
# Short-Description: @{product.name} SonarQube server (www.sonarsource.org)
# Description: @{product.name} SonarQube server (www.sonarsource.org)
### END INIT INFO

# Script variables
SONAR_HOME="@{package.app}"
SONAR_USER="@{package.user}"
ARCH=`uname -m`

# For SELinux we need to use 'runuser' not 'su'
if [ -x "/sbin/runuser" ]; then
	SU="/sbin/runuser -s /bin/bash"
else
	SU="/bin/su -s /bin/bash"
fi

# Launch appropriate wrapper
if [ "$ARCH" = "x86_64" ]; then
	$SU - $SONAR_USER -c "$SONAR_HOME/bin/linux-x86-64/sonar.sh $*"
else
	$SU - $SONAR_USER -c "$SONAR_HOME/bin/linux-x86-32/sonar.sh $*"
fi
