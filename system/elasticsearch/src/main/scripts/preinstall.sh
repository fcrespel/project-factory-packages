# Stop the service for safety
stopservice @{package.service}

# Disable Nagios monitoring
if type -t nagios_disable_service >/dev/null; then
	nagios_disable_service "Elasticsearch HTTP"
	nagios_disable_service "Elasticsearch TCP"
fi
