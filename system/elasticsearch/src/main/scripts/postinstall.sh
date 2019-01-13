# Fix script permissions
chmod +x @{package.app}/bin/*
chmod +x @{package.app}/bin/x-pack/*
chmod +x @{package.app}/modules/x-pack-ml/platform/linux-x86_64/bin/*

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
