#!/bin/sh
#
# PHP user profile configuration.
# By Fabien CRESPEL <fabien@crespel.net>
#

COMPOSER_HOME="@{package.app}/composer"
if [ -e "$COMPOSER_HOME/vendor/bin" ]; then
    export PATH="$COMPOSER_HOME/vendor/bin:$PATH"
    export COMPOSER_HOME
fi
