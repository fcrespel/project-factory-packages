PEAR_CFG="@{product.root}/.pearrc"

# Configure PEAR
pear config-create "@{package.app}" "$PEAR_CFG" > /dev/null
pear -c "$PEAR_CFG" config-set auto_discover 1 > /dev/null
chown @{product.user}:@{product.group} "$PEAR_CFG"

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
