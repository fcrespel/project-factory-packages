# Disable cron jobs
touch "@{product.bin}/cron.5mins/redmine-jenkins-sync.sh.lock"
touch "@{product.bin}/cron.5mins/redmine-ldap-sync.sh.lock"
touch "@{product.bin}/cron.daily/redmine-reminders.sh.lock"

# Disable Nagios monitoring
if type -t nagios_disable_service >/dev/null; then
	nagios_disable_service "Redmine"
fi

# Disable user access to the service
if type -t httpd_disable_service >/dev/null; then
	httpd_disable_service redmine
fi
