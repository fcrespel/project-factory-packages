#!/bin/bash
#
# Project Factory - Ruby Functions
# By Fabien CRESPEL <fabien@crespel.net>
#

# Execute a RVM command
function rvm
{
	if [ -z "$RVM_DIR" ]; then
		printerror "ERROR: RVM directory is not defined or is empty"
		return 1
	fi
	"$RVM_DIR/bin/rvm" "$@"
}

# Execute a RVM command without displaying the output
function rvm_quiet
{
	rvm "$@" > /dev/null 2>&1
}

# Install Ruby gems from a local source
function installgems
{
	local RUBY_VERSION="$1"
	local RUBY_GEMS="$2"
	local RUBY_GEMS_DIR="@{package.app}/gems"
	for RUBY_GEM in $RUBY_GEMS; do
		RUYGEM_OUTPUT=`mktemp --tmpdir=$PRODUCT_TMP`
		if ! rvm $RUBY_VERSION do gem install --local $RUBY_GEMS_DIR/$RUBY_GEM.gem --no-document > "$RUYGEM_OUTPUT" 2>&1; then
			cat "$RUYGEM_OUTPUT"
			rm -f "$RUYGEM_OUTPUT"
			printerror "ERROR: failed to install Ruby gem '$RUBY_GEM' for Ruby version $RUBY_VERSION"
			return 1
		fi
		rm -f "$RUYGEM_OUTPUT"
	done
	return 0
}
