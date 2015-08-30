# Interpolate template
interpolatetemplate_inplace "@{package.app}/conf/sonar-runner.properties"

# Fix permissions
chmod +x "@{package.app}/bin/sonar-runner"
chown -R @{package.user}:@{package.group} "@{package.data}"
chmod -R ug=rwX "@{package.data}"

# Create link to data directory
if [ ! -e "@{product.root}/.sonar" -a ! -h "@{product.root}/.sonar" ]; then
	ln -s "@{package.data}" "@{product.root}/.sonar" && chown -h @{package.user}:@{package.group} "@{product.root}/.sonar"
fi
