if [ -z "$LDAP_ROOT_PASSWORD" ]; then
	printerror "ERROR: missing LDAP_ROOT_PASSWORD configuration value, please install the '@{package.prefix}-system-ldap' package first or configure it manually."
	exit 1
fi

# Disable cron job
if type -t cron_disable_job >/dev/null; then
	cron_disable_job "@{product.bin}/cron.5mins/svn-ldap-sync.sh"
fi
