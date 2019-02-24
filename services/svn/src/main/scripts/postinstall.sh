# Interpolate templates
interpolatetemplate_inplace "@{package.app}/ldap_sync.sh"

# Initialize logs
touch "@{package.log}/svn_log" && chown @{httpd.user}:@{httpd.group} "@{package.log}/svn_log"
touch "@{package.log}/ldap_sync.log" && chown @{product.user}:@{product.group} "@{package.log}/ldap_sync.log"

# Update repository hooks
find "@{package.data}/repos" -mindepth 1 -maxdepth 1 -type d | while read REPO; do
	"@{package.app}/mkrepo-post-create.sh" "$REPO" > /dev/null 2>&1
done

# Fix data directory and authz file permissions
chown -R @{httpd.user}:@{httpd.group} "@{package.data}"
chmod -R ug=rwX "@{package.data}"

# Reload HTTPD and Nagios if already running
reloadservice @{httpd.service}
reloadservice @{nagios.service}

# Enable cron job
if type -t cron_enable_job >/dev/null; then
	cron_enable_job "@{product.bin}/cron.5mins/svn-ldap-sync.sh"
fi
