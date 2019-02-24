# Disable cron jobs
if type -t cron_disable_job >/dev/null; then
	cron_disable_job "@{product.bin}/cron.5mins/redmine-ldap-sync.sh"
	cron_disable_job "@{product.bin}/cron.daily/redmine-reminders.sh"
	cron_disable_job "@{product.bin}/cron.daily/redmine-attachments-prune.sh"
	cron_disable_job "@{product.bin}/cron.hourly/redmine-repo-sync.sh"
fi

# Disable Nagios monitoring
if type -t nagios_disable_service >/dev/null; then
	nagios_disable_service "Redmine"
fi

# Disable user access to the service
if type -t httpd_disable_service >/dev/null; then
	httpd_disable_service redmine
fi
