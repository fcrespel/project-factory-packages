# Disable Nagios monitoring
if type -t nagios_disable_service >/dev/null; then
	nagios_disable_service "phpMyAdmin"
fi

# Disable user access to the service
if type -t httpd_disable_service >/dev/null; then
	httpd_disable_service phpmyadmin
fi
