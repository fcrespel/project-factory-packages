# Interpolate users configuration
interpolatetemplate_inplace "@{package.app}/conf/tomcat-users.xml"

# Create trust store if necessary
create_truststore "@{package.app}/conf/trust.jks" @{package.user} @{package.group} "@{system.java7.app}/jre/lib/security/cacerts"

# Enable service at startup
if ! enableservice @{package.service}; then
	exit 1
fi

# Reload Nagios if already running
reloadservice @{nagios.service}

# Enable Nagios monitoring
if type -t nagios_enable_service >/dev/null; then
	nagios_enable_service "Tomcat AJP"
	nagios_enable_service "Tomcat HTTP"
fi
