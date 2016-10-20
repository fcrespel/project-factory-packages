# Disable Nagios monitoring
if type -t nagios_disable_service >/dev/null; then
	nagios_disable_service "Jenkins"
fi

# Disable user access to the service
if type -t httpd_disable_service >/dev/null; then
	httpd_disable_service jenkins
fi

# Stop the service for safety
stopservice @{package.service}

# Rename existing HPI plugins to JPI
if [ -e "@{package.data}/plugins" ]; then
	find "@{package.data}/plugins" -maxdepth 1 -name '*.hpi' | while read FILE; do
		mv "$FILE" "${FILE%.hpi}.jpi"
	done
fi
