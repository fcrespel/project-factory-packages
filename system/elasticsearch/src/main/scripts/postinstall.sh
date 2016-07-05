# Fix script permissions
chmod +x "@{package.app}/bin/elasticsearch"
chmod +x "@{package.app}/bin/elasticsearch.in.sh"
chmod +x "@{package.app}/bin/plugin"

# Fix directory permissions
chown -R @{package.user}:@{package.group} "@{package.app}" "@{package.backup}" "@{package.data}" "@{package.log}"

# Enable service at startup
if ! enableservice @{package.service}; then
	exit 1
fi

# Reload Nagios if already running
reloadservice @{nagios.service}

# Enable Nagios monitoring
if type -t nagios_enable_service >/dev/null; then
	nagios_enable_service "Elasticsearch HTTP"
	nagios_enable_service "Elasticsearch TCP"
fi
