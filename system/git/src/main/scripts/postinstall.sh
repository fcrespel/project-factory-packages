# Fix script permissions
chmod +x "@{package.app}/src/check_bindir" @{package.app}/src/*.sh

# Make and install
( cd "@{package.app}/src" && make distclean ) > /dev/null 2>&1
if ! ( cd "@{package.app}/src" && make configure && ./configure --prefix="@{package.app}" && make all ); then
	printerror "ERROR: failed to compile Git"
	exit 1
fi
if ! ( cd "@{package.app}/src" && make install ); then
	printerror "ERROR: failed to install Git"
	exit 1
fi
( cd "@{package.app}/src" && make distclean ) > /dev/null 2>&1
