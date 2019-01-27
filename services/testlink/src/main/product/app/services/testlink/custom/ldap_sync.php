<?php
/**
 * TestLink LDAP synchronization script.
 * By Fabien CRESPEL <fabien@crespel.net>
 */

require_once(dirname(__FILE__) . '/../config.inc.php');
require_once(dirname(__FILE__) . '/../lib/functions/users.inc.php');
require_once(dirname(__FILE__) . '/../lib/functions/ldap_api.php');

// Execute the synchronization
ldap_sync() || exit(1);


/**
 * Synchronize LDAP users with DB users, creating missing ones as needed.
 * @return bool true if successful, false if an error occurs
 */
function ldap_sync() {
	$authCfg = config_get('authentication');
	
	// Check if LDAP is enabled
	if ($authCfg['method'] != 'LDAP')
		return true;
	
	// Print LDAP info
	echo "Synchronizing users with LDAP root DN " . $authCfg['ldap'][1]['ldap_root_dn'] . " ...\n";
	
	// Connect to the database
	$dbResult = doDBConnect($db);
	if (!$dbResult['status'])
		return false;
	
	// Find all users in DB
	$dbUsers = db_find_all_users($db);
	
	// Find all users in LDAP directory
	$ldapUsers = ldap_find_all_users();
	if ($ldapUsers === false)
		return false;
	
	// Loop over LDAP users
	foreach ($ldapUsers as $login => $ldapUser) {
		if (isset($dbUsers[$login])) {
			echo "-- Updating user $login ...";
			$dbUser = $dbUsers[$login];
			unset($dbUsers[$login]);
		} else {
			echo "-- Creating user $login ...";
			$dbUser = new tlUser();
		}
		if (map_ldap_user_to_db($ldapUser, $dbUser)) {
			if (($dbResult = $dbUser->writeToDB($db)) < tl::OK) {
				echo " failed (code $dbResult)";
			}
		}
		echo "\n";
	}
	
	// Disable remaining DB users
	foreach ($dbUsers as $login => $dbUser) {
		if ($dbUser->isActive) {
			echo "-- Disabling user $login ...";
			$dbUser->isActive = 0;
			if (($dbResult = $dbUser->writeToDB($db)) < tl::OK) {
				echo " failed (code $dbResult)";
			}
			echo "\n";
		}
	}
	
	return true;
}

/**
 * Find all users in LDAP directory.
 * @return array LDAP users
 */
function ldap_find_all_users() {
	$authCfg = config_get('authentication');
	$ldapCfg = $authCfg['ldap'][1];
	$searchFilter = $ldapCfg['ldap_organization'];
	$searchAttrs = array('dn', $ldapCfg['ldap_uid_field']);
	if (isset($ldapCfg['ldap_firstname_field']))
		$searchAttrs[] = $ldapCfg['ldap_firstname_field'];
	if (isset($ldapCfg['ldap_lastname_field']))
		$searchAttrs[] = $ldapCfg['ldap_lastname_field'];
	if (isset($ldapCfg['ldap_mail_field']))
		$searchAttrs[] = $ldapCfg['ldap_mail_field'];
	
	$users = false;
	$connect = ldap_connect_bind($ldapCfg);
	if ($connect->status == 0) {
		$results = ldap_search($connect->handler, $ldapCfg['ldap_root_dn'], $searchFilter, $searchAttrs );
		$entries = ldap_get_entries($connect->handler, $results);
		$users = array();
		for ($i = 0; $i < $entries['count']; $i++) {
			$entry = $entries[$i];
			if (isset($entry[$ldapCfg['ldap_uid_field']]) && !empty($entry[$ldapCfg['ldap_uid_field']])) {
				$users[$entry[$ldapCfg['ldap_uid_field']][0]] = $entry;
			}
		}
	} else {
		echo "Failed to list LDAP users: " . $connect->info . " (" . $connect->error . ")\n";
	}
	
	return $users;
}

/**
 * Find all users in local database.
 * @return array DB users
 */
function db_find_all_users($db) {
	$users = array();
	$usersRaw = getAllUsersRoles($db);
	foreach ($usersRaw as $user) {
		$users[$user->login] = $user;
	}
	return $users;
}

/**
 * Map a LDAP user to a database user.
 * @param array $ldapUser LDAP user
 * @param tlUser $dbUser DB user
 * @return bool true if the DB user was updated, false otherwise
 */
function map_ldap_user_to_db($ldapUser, &$dbUser) {
	$authCfg = config_get('authentication');
	$ldapCfg = $authCfg['ldap'][1];
	$isUpdated = false;
	$map = array(
		'login' => strtolower($ldapCfg['ldap_uid_field']),
		'firstName' => isset($ldapCfg['ldap_firstname_field']) ? strtolower($ldapCfg['ldap_firstname_field']) : '',
		'lastName' => isset($ldapCfg['ldap_lastname_field']) ? strtolower($ldapCfg['ldap_lastname_field']) : '',
		'emailAddress' => isset($ldapCfg['ldap_mail_field']) ? strtolower($ldapCfg['ldap_mail_field']) : '',
	);
	foreach ($map as $dbKey => $ldapKey) {
		if (isset($ldapUser[$ldapKey]) && !empty($ldapUser[$ldapKey]) && !empty($ldapUser[$ldapKey][0]) && strcmp($dbUser->$dbKey, $ldapUser[$ldapKey][0]) != 0) {
			$dbUser->$dbKey = $ldapUser[$ldapKey][0];
			$isUpdated = true;
		}
	}
	if (!$dbUser->isActive) {
		$dbUser->isActive = 1;
		$isUpdated = true;
	}
	return $isUpdated;
}
