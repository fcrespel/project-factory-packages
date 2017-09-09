# Disable Nagios monitoring
if type -t nagios_disable_service >/dev/null; then
	nagios_disable_service "Alfresco Solr AJP"
	nagios_disable_service "Alfresco Solr HTTP"
fi

# Disable user access to the service
if type -t httpd_disable_service >/dev/null; then
	httpd_disable_service alfresco-solr
fi

# Stop the service for safety
stopservice @{package.service}
