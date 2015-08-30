interpolatetemplate_inplace "@{package.app}/conf/settings.xml"

# Fix data directory permissions
mkdir -p "@{product.data}/system/maven/repository"
chown -R @{product.user}:@{product.group} "@{product.data}/system/maven/repository"
chmod -R ug=rwX "@{product.data}/system/maven/repository"

# Create link to repository in user home
if [ ! -e "@{product.root}/.m2/repository" -a ! -h "@{product.root}/.m2/repository" ]; then
	mkdir -p "@{product.root}/.m2" && chown @{package.user}:@{package.group} "@{product.root}/.m2"
	ln -s "@{product.data}/system/maven/repository" "@{product.root}/.m2/repository" && chown -h @{package.user}:@{package.group} "@{product.root}/.m2/repository"
fi

# Fix executable permissions
chmod +x "@{package.app}/bin/mvn"
chmod +x "@{package.app}/bin/mvnDebug"
