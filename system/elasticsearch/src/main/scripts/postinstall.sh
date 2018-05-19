# Fix script permissions
chmod +x "@{package.app}/bin/elasticsearch"
chmod +x "@{package.app}/bin/elasticsearch-env"
chmod +x "@{package.app}/bin/elasticsearch-keystore"
chmod +x "@{package.app}/bin/elasticsearch-plugin"
chmod +x "@{package.app}/bin/elasticsearch-translog"

# Fix directory permissions
mkdir -p "@{package.app}/plugins"
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
