# Store configuration
storevar LDAP_ROOTDN "@{ldap.root.dn}"
storevar LDAP_BASEDN "@{ldap.base.dn}"
storevar LDAP_HOST "@{ldap.host}"
storevar LDAP_PORT "@{ldap.port}"

# Generate passwords
ensurepassword LDAP_ROOT_PASSWORD
LDAP_ROOT_PASSWORD_SSHA=`slappasswd -h '{SSHA}' -s "$LDAP_ROOT_PASSWORD"`
ROOT_PASSWORD_SSHA=`slappasswd -h '{SSHA}' -s "$ROOT_PASSWORD"`
BOT_PASSWORD_SSHA=`slappasswd -h '{SSHA}' -s "$BOT_PASSWORD"`

# Interpolate templates
interpolatetemplate_inplace "@{package.app}/conf.d/cn=config/olcDatabase={0}config.ldif"
interpolatetemplate_inplace "@{package.app}/conf.d/cn=config/olcDatabase={2}hdb.ldif"
interpolatetemplate_inplace "@{package.app}/populate_database.ldif"

# Fix data and app/run directory permissions
chown -R @{package.user}:@{package.group} "@{package.data}"
chown -R @{package.user}:@{package.group} "@{package.app}/run"

# Enable service at startup
if ! enableservice @{package.service} reload; then
	exit 1
fi
sleep 2

# Populate database if necessary
LDAP_BASERDN_ATTR=`ldap_getattr "(objectClass=@{ldap.base.class})" @{ldap.base.rdn.attr}`
if [ -z "$LDAP_BASERDN_ATTR" ] && ! cat "@{package.app}/populate_database.ldif" | ldap_add > /dev/null; then
	printerror "ERROR: failed to populate LDAP database for base DN $LDAP_BASEDN"
	exit 1
fi

# Reload Nagios if already running
reloadservice @{nagios.service}
