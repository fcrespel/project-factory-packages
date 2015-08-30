# Interpolate template
interpolatetemplate_inplace "@{package.app}/service.conf"

# Fix data directory permissions
chown -R @{package.user}:@{package.group} "@{package.data}"

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
