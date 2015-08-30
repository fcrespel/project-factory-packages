export RAILS_ENV="production"
POSTINSTALL_OUTPUT=`mktemp --tmpdir=$PRODUCT_TMP`
NPROC=`nproc`

# Interpolate templates
ensurepassword GITLAB_DB_PASSWORD
interpolatetemplate_inplace "@{package.app}/config/database.yml"
interpolatetemplate_inplace "@{package.app}/config/gitlab.yml"
interpolatetemplate_inplace "@{package.app}/config/overlay.sql"
cp "@{package.app}/config/initializers/rack_attack.rb.example" "@{package.app}/config/initializers/rack_attack.rb"

# Fix execute permissions
chmod +x @{package.app}/bin/* @{package.app}/shell/bin/* @{package.app}/shell/hooks/*

# Configure user
usermod -s /bin/bash @{package.user} > /dev/null 2>&1
mkdir -p "@{package.root}/.ssh" && touch "@{package.root}/.ssh/authorized_keys"

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
	printerror "ERROR: failed to install required Gems for GitLab"
	exit 1
fi

# Start MySQL if necessary
if ! startservice @{mysql.service}; then
	exit 1
fi

# Create database and user if necessary
DO_DBINIT=`if mysql_dbexists "@{gitlab.db.name}"; then echo 0; else echo 1; fi`
if ! mysql_createdb "@{gitlab.db.name}" || ! mysql_createuser "@{gitlab.db.user}" "$GITLAB_DB_PASSWORD" "@{gitlab.db.name}"; then
	rm -f "$POSTINSTALL_OUTPUT"
	exit 1
fi

# Initialize database content
if [ "$DO_DBINIT" -eq 1 ]; then
	# Create schema and load default data
	if ! ( cd "@{package.app}" && rvm default do bundle exec rake gitlab:setup force=yes GITLAB_ROOT_PASSWORD=$ROOT_PASSWORD ) > "$POSTINSTALL_OUTPUT" 2>&1; then
		cat "$POSTINSTALL_OUTPUT"
		rm -f "$POSTINSTALL_OUTPUT"
		printerror "ERROR: failed to initialize GitLab database"
		exit 1
	fi
else
	# Migrate schema and data
	if ! ( cd "@{package.app}" && rvm default do bundle exec rake db:migrate ) > "$POSTINSTALL_OUTPUT" 2>&1; then
		cat "$POSTINSTALL_OUTPUT"
		rm -f "$POSTINSTALL_OUTPUT"
		printerror "ERROR: failed to migrate GitLab database"
		exit 1
	fi
fi

# Apply SQL overlay
if ! cat "@{package.app}/config/overlay.sql" | mysql_exec "@{gitlab.db.name}" > "$POSTINSTALL_OUTPUT" 2>&1; then
	cat "$POSTINSTALL_OUTPUT"
	rm -f "$POSTINSTALL_OUTPUT"
	printerror "ERROR: failed to apply overlay to GitLab database"
	exit 1
fi

# Clean up assets and cache
if ! ( cd "@{package.app}" && rvm default do bundle exec rake assets:clean assets:precompile cache:clear RAILS_RELATIVE_URL_ROOT=/gitlab ) > "$POSTINSTALL_OUTPUT" 2>&1; then
	cat "$POSTINSTALL_OUTPUT"
	rm -f "$POSTINSTALL_OUTPUT"
	printerror "ERROR: failed to clean up assets and cache for GitLab"
	exit 1
fi

# Clean up temp file and permissions
rm -f "$POSTINSTALL_OUTPUT"
chown -R @{package.user}:@{package.group} "@{package.app}" "@{package.data}" "@{package.log}"
chmod -R ug+rwX,o-rwx @{package.data}/repositories/
chmod -R ug-s @{package.data}/repositories/
find @{package.data}/repositories/ -type d -print0 | xargs -0 chmod g+s
chmod u+rwx,g=rx,o-rwx @{package.data}/satellites

# Configure Git
su -s /bin/bash - @{package.user} -c "git config --global user.name GitLab"
su -s /bin/bash - @{package.user} -c "git config --global user.email gitlab@@{product.domain}"
su -s /bin/bash - @{package.user} -c "git config --global core.autocrlf input"

# Enable service at startup
if ! enableservice @{package.service}; then
	exit 1
fi

# Reload HTTPD and Nagios if already running
reloadservice @{httpd.service}
reloadservice @{nagios.service}

# Enable user access to the service
if type -t httpd_enable_service >/dev/null; then
	httpd_enable_service gitlab
fi

# Enable Nagios monitoring
if type -t nagios_enable_service >/dev/null; then
	nagios_enable_service "GitLab"
fi
