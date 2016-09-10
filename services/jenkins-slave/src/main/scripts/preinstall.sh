# Check required config vars
if [ -z "$JENKINS_SLAVE_NODENAME" ]; then
	printerror "ERROR: missing JENKINS_SLAVE_NODENAME configuration value, please configure it manually."
	exit 1
elif [ -z "$JENKINS_SLAVE_SECRET" ]; then
	printerror "ERROR: missing JENKINS_SLAVE_SECRET configuration value, please configure it manually."
	exit 1
fi

# Disable Nagios monitoring
if type -t nagios_disable_service >/dev/null; then
	nagios_disable_service "Jenkins Slave"
fi

# Stop the service for safety
stopservice @{package.service}
