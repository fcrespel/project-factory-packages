export RAILS_ENV="production"
POSTINSTALL_OUTPUT=`mktemp --tmpdir=$PRODUCT_TMP`
NPROC=`nproc`

# Interpolate templates
ensurepassword REDMINE_DB_PASSWORD
ensurepassword REDMINE_SYS_API_KEY 20
interpolatetemplate_inplace "@{package.app}/config/database.yml"
interpolatetemplate_inplace "@{package.app}/config/overlay.sql"

# Initialize logs
touch "@{package.log}/$RAILS_ENV.log" && chown @{package.user}:@{package.group} "@{package.log}/$RAILS_ENV.log"
touch "@{package.log}/ldap_sync.log" && chown @{product.user}:@{product.group} "@{package.log}/ldap_sync.log"

# Check if bundler is available
BUNDLER=`rvm default do which bundle`
if [ ! -x "$BUNDLER" ]; then
	printerror "ERROR: the 'bundle' command is not available or not executable"
	exit 1
fi

# Execute bundler to install required gems
rvm default do bundle config build.nokogiri --use-system-libraries > /dev/null 2>&1
if ! ( cd "@{package.app}" && rvm default do bundle install --jobs $NPROC --deployment --local ) > "$POSTINSTALL_OUTPUT" 2>&1; then
	cat "$POSTINSTALL_OUTPUT"
	rm -f "$POSTINSTALL_OUTPUT"
	printerror "ERROR: failed to install required Gems for Redmine"
	exit 1
fi

# Generate session store
( cd "@{package.app}" && rm -f "config/initializers/secret_token.rb" && rvm default do bundle exec rake generate_secret_token )

# Start MySQL if necessary
if ! startservice @{mysql.service}; then
	exit 1
fi

# Create database and user if necessary
DO_DBINIT=`if mysql_dbexists "@{redmine.db.name}"; then echo 0; else echo 1; fi`
if ! mysql_createdb "@{redmine.db.name}" || ! mysql_createuser "@{redmine.db.user}" "$REDMINE_DB_PASSWORD" "@{redmine.db.name}"; then
	rm -f "$POSTINSTALL_OUTPUT"
	exit 1
fi

# Migrate database structure
if ! ( cd "@{package.app}" && rvm default do bundle exec rake db:migrate && rvm default do bundle exec rake redmine:plugins:migrate ) > "$POSTINSTALL_OUTPUT" 2>&1; then
	cat "$POSTINSTALL_OUTPUT"
	rm -f "$POSTINSTALL_OUTPUT"
	printerror "ERROR: failed to migrate Redmine database"
	exit 1
fi

# Initialize database content
if [ "$DO_DBINIT" -eq 1 ]; then
	# Load default data
	if ! ( cd "@{package.app}" && REDMINE_LANG=@{redmine.lang} rvm default do bundle exec rake redmine:load_default_data ) > "$POSTINSTALL_OUTPUT" 2>&1; then
		cat "$POSTINSTALL_OUTPUT"
		rm -f "$POSTINSTALL_OUTPUT"
		printerror "ERROR: failed to load default data into Redmine"
		exit 1
	fi
	
	# Apply SQL overlay
	if ! cat "@{package.app}/config/overlay.sql" | mysql_exec "@{redmine.db.name}" > "$POSTINSTALL_OUTPUT" 2>&1; then
		cat "$POSTINSTALL_OUTPUT"
		rm -f "$POSTINSTALL_OUTPUT"
		printerror "ERROR: failed to apply overlay to Redmine database"
		exit 1
	fi
fi

# Move attachment files to subdirectories
( cd "@{package.app}" && rvm default do bundle exec rake redmine:attachments:move_to_subdirectories ) > /dev/null 2>&1

# Cleanup
( cd "@{package.app}" && rvm default do bundle exec rake tmp:cache:clear && rvm default do bundle exec rake tmp:sessions:clear ) > /dev/null 2>&1
rm -f "$POSTINSTALL_OUTPUT"
chown -R @{package.user}:@{package.group} "@{package.app}" "@{package.data}"

# Reload HTTPD and Nagios if already running
reloadservice @{httpd.service}
reloadservice @{nagios.service}

# Enable user access to the service
if type -t httpd_enable_service >/dev/null; then
	httpd_enable_service redmine
fi

# Enable Nagios monitoring
if type -t nagios_enable_service >/dev/null; then
	nagios_enable_service "Redmine"
fi

# Enable cron jobs
rm -f "@{product.bin}/cron.5mins/redmine-jenkins-sync.sh.lock"
rm -f "@{product.bin}/cron.5mins/redmine-ldap-sync.sh.lock"
rm -f "@{product.bin}/cron.daily/redmine-reminders.sh.lock"
rm -f "@{product.bin}/cron.daily/redmine-attachments-prune.sh.lock"
rm -f "@{product.bin}/cron.hourly/redmine-repo-sync.sh.lock"
