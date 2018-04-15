if [ -z "$LDAP_ROOT_PASSWORD" ]; then
	printerror "ERROR: missing LDAP_ROOT_PASSWORD configuration value, please install the '@{package.prefix}-system-ldap' package first or configure it manually."
	exit 1
fi

# Migrate old data
if [ -e "@{product.backup}/services/alfresco-explorer" -a ! -e "@{package.backup}" ]; then
	mv "@{product.backup}/services/alfresco-explorer" "@{package.backup}"
fi
if [ -e "@{product.data}/services/alfresco-explorer" -a ! -e "@{package.data}" ]; then
	mv "@{product.data}/services/alfresco-explorer" "@{package.data}"
fi

# Disable Nagios monitoring
if type -t nagios_disable_service >/dev/null; then
	nagios_disable_service "Alfresco Platform AJP"
	nagios_disable_service "Alfresco Platform HTTP"
fi

# Disable user access to the service
if type -t httpd_disable_service >/dev/null; then
	httpd_disable_service alfresco-platform
fi

# Stop the service for safety
stopservice @{package.service}
