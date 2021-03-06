#!/bin/sh
#
# Maven user profile configuration.
# By Fabien CRESPEL <fabien@crespel.net>
#

M2_HOME="@{package.app}"
if [ -e "$M2_HOME" ]; then
    export PATH="$M2_HOME/bin:$PATH"
    export MAVEN_OPTS="-Xmx512m -Djavax.net.ssl.trustStore=@{package.data}/trust.jks"
    export M2_HOME
fi
