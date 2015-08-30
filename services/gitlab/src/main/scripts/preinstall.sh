if [ -z "$LDAP_ROOT_PASSWORD" ]; then
	printerror "ERROR: missing LDAP_ROOT_PASSWORD configuration value, please install the '@{package.prefix}-system-ldap' package first or configure it manually."
	exit 1
fi

# Stop the service for safety
stopservice @{package.service}

# Disable Nagios monitoring
if type -t nagios_disable_service >/dev/null; then
	nagios_disable_service "GitLab"
fi

# Disable user access to the service
if type -t httpd_disable_service >/dev/null; then
	httpd_disable_service gitlab
fi
