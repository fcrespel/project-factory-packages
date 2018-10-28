# Extract Composer binaries
tar -C "@{package.app}/composer/vendor" -xf "@{package.app}/composer/vendor/bin.tar"

# Purge sessions
find "@{package.data}/sessions" -name 'sess_*' -delete

# Fix file and directory permissions
chown -R @{package.user}:@{package.group} "@{package.app}" "@{package.data}/sessions"
chmod -R ug=rwX "@{package.data}/sessions"
chmod +x @{package.app}/composer/vendor/bin/*

# Reload HTTPD if already running
reloadservice @{httpd.service}
