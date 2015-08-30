# Disable Nagios monitoring
if type -t nagios_disable_service >/dev/null; then
	nagios_disable_service "Nexus"
fi

# Disable user access to the service
if type -t httpd_disable_service >/dev/null; then
	httpd_disable_service nexus
fi

# Stop the service for safety
stopservice @{package.service}
