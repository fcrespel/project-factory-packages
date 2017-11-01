export RAILS_ENV="production"
NPROC=`nproc`

# Interpolate templates
ensurepassword GITLAB_DB_PASSWORD
interpolatetemplate_inplace "@{package.app}/config/database.yml"
interpolatetemplate_inplace "@{package.app}/config/gitlab.yml"
interpolatetemplate_inplace "@{package.app}/config/overlay.sql"
if [ ! -e "@{package.app}/config/secrets.yml" ]; then
	cp "@{package.app}/config/secrets.yml.example" "@{package.app}/config/secrets.yml"
fi

# Fix execute permissions
chmod +x @{package.app}/bin/* @{package.app}/lib/support/init.d/gitlab @{package.app}/shell/bin/* @{package.app}/shell/hooks/* @{package.app}/gitaly/ruby/bin/*

# Configure user
usermod -s /bin/bash @{package.user} > /dev/null 2>&1
mkdir -p "@{package.root}/.ssh" && touch "@{package.root}/.ssh/authorized_keys"

# Build workhorse
if ! ( chown -R @{package.user}:@{package.group} "@{package.app}/workhorse" && su -c "cd @{package.app}/workhorse && make" - @{package.user} ); then
	printerror "ERROR: failed to build Gitlab Workhorse"
	exit 1
fi

# Build Gitaly
if ! ( chown -R @{package.user}:@{package.group} "@{package.app}/gitaly" && su -c "cd @{package.app}/gitaly && make" - @{package.user} ); then
	printerror "ERROR: failed to build Gitaly"
	exit 1
fi

# Check if bundler is available
BUNDLER=`rvm default do which bundle`
if [ ! -x "$BUNDLER" ]; then
	printerror "ERROR: the 'bundle' command is not available or not executable"
	exit 1
fi

# Execute bundler to install required gems
rvm default do bundle config build.nokogiri --use-system-libraries > /dev/null 2>&1
if ! ( cd "@{package.app}" && rvm default do bundle install --jobs $NPROC --deployment --local ); then
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
	exit 1
fi

# Fix MySQL settings and elevate privileges
echo "SET GLOBAL log_bin_trust_function_creators = 1;" | mysql_exec
echo "GRANT ALL PRIVILEGES ON *.* TO '@{gitlab.db.user}'@'localhost';" | mysql_exec

# Initialize database content
if [ "$DO_DBINIT" -eq 1 ]; then
	# Create schema and load default data
	if ! ( cd "@{package.app}" && rvm default do bundle exec rake gitlab:setup force=yes GITLAB_ROOT_PASSWORD="$ROOT_PASSWORD" GITLAB_ROOT_EMAIL="@{root.user}@@{product.domain}" ); then
		printerror "ERROR: failed to initialize GitLab database"
		exit 1
	fi
else
	# Migrate schema and data
	if ! ( cd "@{package.app}" && rvm default do bundle exec rake db:migrate ); then
		printerror "ERROR: failed to migrate GitLab database"
		exit 1
	fi
fi

# Revoke MySQL privileges
echo "REVOKE ALL PRIVILEGES ON *.* FROM '@{gitlab.db.user}'@'localhost';" | mysql_exec

# Apply SQL overlay
if ! cat "@{package.app}/config/overlay.sql" | mysql_exec "@{gitlab.db.name}"; then
	printerror "ERROR: failed to apply overlay to GitLab database"
	exit 1
fi

# Compile GetText PO files
if ! ( cd "@{package.app}" && rvm default do bundle exec rake gettext:compile ); then
	printerror "ERROR: failed to compile GetText PO files for GitLab"
	exit 1
fi

# Compile assets and clean up cache
if ! ( cd "@{package.app}" && rvm default do bundle exec rake yarn:install gitlab:assets:clean gitlab:assets:compile cache:clear RAILS_RELATIVE_URL_ROOT=/gitlab ); then
	printerror "ERROR: failed to compile assets and clean up cache for GitLab"
	exit 1
fi

# Fix permissions
chown -R @{package.user}:@{package.group} "@{package.app}" "@{package.data}" "@{package.log}"
chmod 0600 "@{package.app}/config/secrets.yml"
chmod 0750 "@{package.data}/uploads"
chmod 0700 "@{package.data}/tmp/sockets/private"
chmod -R ug+rwX,o-rwx "@{package.data}/repositories/"
chmod -R ug-s "@{package.data}/repositories/"
find "@{package.data}/repositories/" -type d -print0 | xargs -0 chmod g+s

# Configure Git
su -s /bin/bash - @{package.user} -c "git config --global user.name GitLab"
su -s /bin/bash - @{package.user} -c "git config --global user.email gitlab@@{product.domain}"
su -s /bin/bash - @{package.user} -c "git config --global core.autocrlf input"
su -s /bin/bash - @{package.user} -c "git config --global gc.auto 0"
su -s /bin/bash - @{package.user} -c "git config --global repack.writeBitmaps true"

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
