# Interpolate template
interpolatetemplate_inplace "@{package.app}/service.conf"

# Create fake cache dir to avoid error during startup
mkdir -p "@{product.root}/.jenkins/cache/jars"

# Fix data directory permissions
chown -R @{package.user}:@{package.group} "@{package.data}"

# Create trust store if necessary
create_truststore "@{package.app}/trust.jks" @{package.user} @{package.group} "@{system.java8.app}/jre/lib/security/cacerts"

# Enable service at startup
if ! enableservice @{package.service}; then
	exit 1
fi

# Reload Nagios if already running
reloadservice @{nagios.service}

# Enable Nagios monitoring
if type -t nagios_enable_service >/dev/null; then
	nagios_enable_service "Jenkins Slave"
fi
