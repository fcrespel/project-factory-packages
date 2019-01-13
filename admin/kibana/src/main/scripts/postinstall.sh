# Fix script permissions
chmod +x @{package.app}/bin/*

# Fix directory permissions
mkdir -p "@{package.app}/plugins"
chown -R @{package.user}:@{package.group} "@{package.app}" "@{package.log}"

# Enable service at startup
if ! enableservice @{package.service}; then
	exit 1
fi

# Reload HTTPD and Nagios if already running
reloadservice @{httpd.service}
reloadservice @{nagios.service}

# Enable user access to the service
if type -t httpd_enable_service >/dev/null; then
	httpd_enable_service kibana
fi

# Enable Nagios monitoring
if type -t nagios_enable_service >/dev/null; then
	nagios_enable_service "Kibana"
fi
