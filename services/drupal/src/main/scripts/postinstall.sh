MODULES_ENABLED="@{drupal.modules.enabled}"
MODULES_DISABLED="@{drupal.modules.disabled}"

# Generate database password
ensurepassword DRUPAL_DB_PASSWORD

# Interpolate template
LDAP_BASE_DN_ARRAY=`/usr/bin/php -r "echo serialize(array('@{ldap.base.dn}'));"`
LDAP_AUTHORIZATION_MAPPINGS=`/usr/bin/php -r "echo serialize(array(array('user_entered' => 'administrator', 'from' => '@{product.group.admins}', 'normalized' => 'administrator', 'simplified' => 'administrator', 'valid' => false, 'error_message' => 'Role <em class="placeholder">administrator</em>_name does not exist and role creation is not enabled.')));"`
interpolatetemplate_inplace "@{package.app}/scripts/overlay.sql"

# Fix for PHP7
sed -i 's#self::#Vars::#g' "@{package.app}/sites/all/modules/vars/vars.module"

# Start MySQL if necessary
if ! startservice @{mysql.service}; then
	exit 1
fi

# Create database and user if necessary
if ! mysql_createdb "@{drupal.db.name}" || ! mysql_createuser "@{drupal.db.user}" "$DRUPAL_DB_PASSWORD" "@{drupal.db.name}"; then
	exit 1
fi

# Install Drupal with Drush if necessary
if [ ! -e "@{package.app}/sites/default/settings.php" ]; then
	# Create site
	if ! drush site-install standard \
		--site-name="@{product.name}" --site-mail="drupal@@{product.domain}" --locale="@{drupal.lang}" \
		--account-name="@{root.user}" --account-mail="@{root.user}@@{product.domain}" --account-pass="$ROOT_PASSWORD" \
		--db-url="mysql://@{drupal.db.user}:$DRUPAL_DB_PASSWORD@@{mysql.host}:@{mysql.port}/@{drupal.db.name}"; then
		printerror "ERROR: failed to install Drupal using Drush"
		exit 1
	fi
	
	# Configure Drupal
	drush_quiet pm-enable "projectfactory"
	drush_quiet variable-set theme_default "projectfactory"
	drush_quiet variable-set user_register "0"
	drush_quiet variable-set update_notification_threshold "security"
	drush_quiet variable-set advanced_forum_style "naked"
	drush_quiet variable-set reverse_proxy "true"
	drush_quiet variable-set reverse_proxy_addresses '["127.0.0.1"]' --format=json
	drush_quiet variable-set proxy_server "$PROXY_HOST"
	drush_quiet variable-set proxy_port "$PROXY_PORT"
	drush_quiet variable-set proxy_exceptions '["localhost","127.0.0.1","@{product.domain}"]' --format=json
	
	# Configure LDAP
	drush_quiet variable-set ldap_user_conf '{"drupalAcctProvisionServer":"local","ldapEntryProvisionServer":0,"drupalAcctProvisionTriggers":{"2":"2","1":"1"},"ldapEntryProvisionTriggers":{"6":0,"7":0,"8":0,"3":0},"orphanedDrupalAcctBehavior":"user_cancel_block","orphanedCheckQty":"100","userConflictResolve":2,"manualAccountConflict":"3","acctCreation":4,"ldapUserSynchMappings":[],"disableAdminPasswordField":1}' --format=json
	drush_quiet variable-set ldap_authentication_conf '{"sids":{"local":"local"},"authenticationMode":2,"loginUIUsernameTxt":null,"loginUIPasswordTxt":null,"ldapUserHelpLinkUrl":null,"ldapUserHelpLinkText":"Logon Help","emailOption":3,"emailUpdate":2,"passwordOption":3,"allowOnlyIfTextInDn":[],"excludeIfTextInDn":[],"allowTestPhp":"","excludeIfNoAuthorizations":null,"ssoRemoteUserStripDomainName":null,"ssoExcludedPaths":[],"ssoExcludedHosts":[],"seamlessLogin":null,"ssoNotifyAuthentication":null,"ldapImplementation":null,"cookieExpire":null,"emailTemplate":"@username@fake-domain.com","emailTemplateHandling":1,"templateUsagePromptUser":0,"templateUsageNeverUpdate":0,"templateUsageResolveConflict":0,"templateUsagePromptRegex":".*@fake-domain\\.com","templateUsageRedirectOnLogin":0}' --format=json
	
	# Configure CAS
	drush_quiet variable-set cas_login_form "2"
	drush_quiet variable-set cas_library_dir ""
	drush_quiet variable-set cas_server "@{cas.host}"
	drush_quiet variable-set cas_port "@{cas.port}"
	drush_quiet variable-set cas_uri "@{cas.context}"
	drush_quiet variable-set cas_version "S1"
	drush_quiet variable-set cas_hide_email "1"
	drush_quiet variable-set cas_hide_password "1"
	drush_quiet variable-set cas_user_register "1"
	drush_quiet variable-set cas_check_first "1"
	drush_quiet variable-set cas_attributes_sync_every_login "1"
	drush_quiet variable-set cas_attributes_overwrite "1"
	drush_quiet variable-set cas_attributes_relations '{"mail":"[cas:attribute:mail:first]"}' --format=json
	drush_quiet variable-set cas_attributes_roles_mapping "groups"
	if [ "@{cas.enabled}" = "1" -o "@{cas.enabled}" = "true" ]; then
		drush_quiet pm-enable cas cas_attributes
	else
		drush_quiet pm-disable cas cas_attributes
	fi
	
	# Enable/disable modules
	for MODULE in $MODULES_ENABLED; do
		[ -n "$MODULE" ] && drush_quiet pm-enable $MODULE
	done
	for MODULE in $MODULES_DISABLED; do
		[ -n "$MODULE" ] && drush_quiet pm-disable $MODULE
	done
	
	# Update database if necessary
	if ! drush updatedb; then
		printerror "ERROR: failed to update Drupal database"
		exit 1
	fi
	
	# Apply SQL overlay
	if ! cat "@{package.app}/scripts/overlay.sql" | mysql_exec "@{drupal.db.name}"; then
		printerror "ERROR: failed to apply overlay to Drupal database"
		exit 1
	fi
else
	# Update database if necessary
	if ! drush updatedb; then
		printerror "ERROR: failed to update Drupal database"
		exit 1
	fi
fi

# Configure RewriteBase
sed -i 's~# RewriteBase /drupal~RewriteBase /drupal~g' "@{package.app}/.htaccess"

# Reset owner and cleanup
drush_quiet cache-clear all
chown -R @{package.user}:@{package.group} "@{package.app}"
chown -R @{httpd.user}:@{httpd.group} "@{package.app}/sites" "@{package.data}"
chmod -R ug=rwX "@{package.app}/sites" "@{package.data}"

# Reload HTTPD and Nagios if already running
reloadservice @{httpd.service}
reloadservice @{nagios.service}

# Enable user access to the service
if type -t httpd_enable_service >/dev/null; then
	httpd_enable_service drupal
fi

# Enable Nagios monitoring
if type -t nagios_enable_service >/dev/null; then
	nagios_enable_service "Drupal"
fi

# Enable cron job
if type -t cron_enable_job >/dev/null; then
	cron_enable_job "@{product.bin}/cron.hourly/drupal-cron.sh"
fi
