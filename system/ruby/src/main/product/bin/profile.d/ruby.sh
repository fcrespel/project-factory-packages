#!/bin/sh
#
# Ruby user profile configuration.
# By Fabien CRESPEL <fabien@crespel.net>
#

export RAILS_ENV="production"
export PASSENGER_TMPDIR="@{product.tmp}"
export PASSENGER_INSTANCE_REGISTRY_DIR="$PASSENGER_TMPDIR"

export rvm_path="@{package.app}/rvm"
if [ -e "$rvm_path/scripts/rvm" ]; then
    source "$rvm_path/scripts/rvm"
fi
