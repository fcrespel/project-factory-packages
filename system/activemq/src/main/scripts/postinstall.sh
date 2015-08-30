# Interpolate templates
interpolatetemplate_inplace "@{package.app}/conf/jetty-realm.properties"

# Fix data and log directory permissions
chown -R @{package.user}:@{package.group} "@{package.data}" "@{package.log}"

# Fix executable permissions
chmod +x "@{package.app}/bin/activemq"
chmod +x "@{package.app}/bin/activemq-admin"
chmod +x "@{package.app}/bin/diag"

# Enable service at startup
if ! enableservice @{package.service}; then
	exit 1
fi

# Reload Nagios if already running
reloadservice @{nagios.service}

# Enable Nagios monitoring
if type -t nagios_enable_service >/dev/null; then
	nagios_enable_service "ActiveMQ"
fi
