interpolatetemplate_inplace "@{package.app}/conf/settings.xml"

# Fix data directory permissions
mkdir -p "@{package.data}/repository"
chown -R @{product.user}:@{product.group} "@{package.data}/repository"
chmod -R ug=rwX "@{package.data}/repository"

# Create trust store if necessary
create_truststore "@{package.data}/trust.jks" @{product.user} @{product.group} "@{system.java8.app}/jre/lib/security/cacerts"

# Create link to repository in user home
if [ ! -e "@{product.root}/.m2/repository" -a ! -h "@{product.root}/.m2/repository" ]; then
	mkdir -p "@{product.root}/.m2" && chown @{product.user}:@{product.group} "@{product.root}/.m2"
	ln -s "@{package.data}/repository" "@{product.root}/.m2/repository" && chown -h @{product.user}:@{product.group} "@{product.root}/.m2/repository"
fi

# Fix executable permissions
chmod +x "@{package.app}/bin/mvn"
chmod +x "@{package.app}/bin/mvnDebug"
