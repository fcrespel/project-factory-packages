# Disable cron job
if type -t cron_disable_job >/dev/null; then
	cron_disable_job "@{product.bin}/cron.hourly/drupal-cron.sh"
fi

# Disable Nagios monitoring
if type -t nagios_disable_service >/dev/null; then
	nagios_disable_service "Drupal"
fi

# Disable user access to the service
if type -t httpd_disable_service >/dev/null; then
	httpd_disable_service drupal
fi
