if [ -z "$SONARQUBE_DB_NAME" ]; then
	printerror "ERROR: missing SONARQUBE_DB_NAME configuration value, please configure it manually."
	exit 1
fi
if [ -z "$SONARQUBE_DB_USER" ]; then
	printerror "ERROR: missing SONARQUBE_DB_USER configuration value, please configure it manually."
	exit 1
fi
if [ -z "$SONARQUBE_DB_PASSWORD" ]; then
	printerror "ERROR: missing SONARQUBE_DB_PASSWORD configuration value, please configure it manually."
	exit 1
fi
