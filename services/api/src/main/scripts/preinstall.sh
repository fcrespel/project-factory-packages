if [ -z "$CAS_DB_PASSWORD" ]; then
	printerror "ERROR: missing CAS_DB_PASSWORD configuration value, please install the '@{package.prefix}-service-cas' package first or configure it manually."
	exit 1
fi

# Disable Nagios monitoring
if type -t nagios_disable_service >/dev/null; then
	nagios_disable_service "Platform API AJP"
	nagios_disable_service "Platform API HTTP"
fi

# Disable user access to the service
if type -t httpd_disable_service >/dev/null; then
	httpd_disable_service api
fi

# Stop the service for safety
stopservice @{package.service}
