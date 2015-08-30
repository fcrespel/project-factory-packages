if [ -z "$LDAP_ROOT_PASSWORD" ]; then
	printerror "ERROR: missing LDAP_ROOT_PASSWORD configuration value, please install the '@{package.prefix}-system-ldap' package first or configure it manually."
	exit 1
fi

# Disable Nagios monitoring
if type -t nagios_disable_service >/dev/null; then
	nagios_disable_service "Alfresco Explorer"
fi

# Disable user access to the service
if type -t httpd_disable_service >/dev/null; then
	httpd_disable_service alfresco-explorer
fi

# Stop the service for safety
stopservice @{package.service}
