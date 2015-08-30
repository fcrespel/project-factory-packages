<?php
/**
 * CAS authentication support.
 * By Fabien CRESPEL <fabien@crespel.net>
 */

require_once(dirname(__FILE__) . '/../lib/functions/users.inc.php');
require_once(dirname(__FILE__) . '/../lib/functions/roles.inc.php');
require_once('CAS.php');

/**
 * Get CAS SSO configuration.
 */
function _getSSOCASConfig($authCfg = null)
{
	$authCfg = is_null($authCfg) ? config_get('authentication') : $authCfg;
	$authCfg = array_merge(array(
		'cas_port' => 443,
		'cas_context' => '',
		'cas_protocol' => CAS_VERSION_2_0,
		'cas_logout_requests_enabled' => true,
		'cas_logout_requests_servers' => false,
		'cas_onthefly_registration' => true,
		'cas_firstname_attribute' => 'givenName',
		'cas_lastname_attribute' => 'sn',
		'cas_mail_attribute' => 'mail',
	), $authCfg);
	return $authCfg;
}

/**
 * Get CAS SSO user and sync attributes.
 */
function _getSSOCASUser(&$dbHandler, &$dbUser, $login, $authCfg = null)
{
	$authCfg = _getSSOCASConfig($authCfg);
	$isUpdated = false;
	
	// Check if user exists in DB
	$dbUser = new tlUser();
	$dbUser->login = $login;
	$exists = ($dbUser->readFromDB($dbHandler, tlUser::USER_O_SEARCH_BYLOGIN) >= tl::OK);
	if (!$exists) {
		if (!$authCfg['cas_onthefly_registration']) {
			return false;
		} else {
			$dbUser = new tlUser();
			$dbUser->login = $login;
			$isUpdated = true;
		}
	}
	
	// Sync CAS attributes with DB user
	$casAttr = phpCAS::getAttributes();
	$map = array(
		'firstName' => $authCfg['cas_firstname_attribute'],
		'lastName' => $authCfg['cas_lastname_attribute'],
		'emailAddress' => $authCfg['cas_mail_attribute'],
	);
	foreach ($map as $dbKey => $casKey) {
		if (isset($casAttr[$casKey]) && !empty($casAttr[$casKey]) && strcmp($dbUser->$dbKey, $casAttr[$casKey]) != 0) {
			$dbUser->$dbKey = $casAttr[$casKey];
			$isUpdated = true;
		}
	}
	
	// Write user to DB if newly created or updated
	if ($isUpdated) {
		$dbUser->writeToDB($dbHandler);
		$dbUser->readFromDB($dbHandler, tlUser::USER_O_SEARCH_BYLOGIN);
	}
	
	return true;
}

/**
 * Do CAS SSO login.
 */
function doSSOCASLogin(&$dbHandler, $authCfg = null)
{
	global $g_tlLogger;
	
	$result = array('status' => tl::ERROR, 'msg' => null);
	$authCfg = _getSSOCASConfig($authCfg);
	if (!isset($authCfg['cas_host']))
	{
		$result['msg'] = "Missing 'cas_host' parameter in configuration";
		return $result;
	}
	
	// Initialize CAS client
	phpCAS::client($authCfg['cas_protocol'], $authCfg['cas_host'], $authCfg['cas_port'], $authCfg['cas_context']);
	phpCAS::setNoCasServerValidation();
	
	// Handle logout requests (single sign-out)
	if ($authCfg['cas_logout_requests_enabled'])
		phpCAS::handleLogoutRequests(true, $authCfg['cas_logout_requests_servers']);
	
	// Redirect to CAS for authentication
	phpCAS::forceAuthentication();
	$login = phpCAS::getUser();
	if (!empty($login))
	{
		$login_exists = _getSSOCASUser($dbHandler, $user, $login, $authCfg);
		if ($login_exists && $user->isActive)
		{
			// Need to do set COOKIE following Mantis model
			$auth_cookie_name = config_get('auth_cookie');
			$expireOnBrowserClose = false;
			setcookie($auth_cookie_name, $user->getSecurityCookie(), $expireOnBrowserClose, '/');			

			// Disallow two sessions within one browser
			if (isset($_SESSION['currentUser']) && !is_null($_SESSION['currentUser']))
			{
				$result['msg'] = lang_get('login_msg_session_exists1') . 
								 ' <a href="logout.php">' . 
								 lang_get('logout_link') . '</a>' . lang_get('login_msg_session_exists2');
			}
			else
			{
				// Setting user's session information
				$_SESSION['currentUser'] = $user;
				$_SESSION['lastActivity'] = time();
				
				$g_tlLogger->endTransaction();
				$g_tlLogger->startTransaction();
				setUserSession($dbHandler, $user->login, $user->dbID, $user->globalRoleID, $user->emailAddress, 
							   $user->locale, null);
				$result['status'] = tl::OK;
			}
		}
		else
		{
			logAuditEvent(TLS("audit_login_failed", $login, $_SERVER['REMOTE_ADDR']), "LOGIN_FAILED",
						  $user->dbID, "users");
		}
	}
	
	return $result;
}

/**
 * Do CAS SSO logout.
 */
function doSSOCASLogout($authCfg = null)
{
	$authCfg = _getSSOCASConfig($authCfg);
	if (isset($authCfg['cas_host']))
	{
		phpCAS::client($authCfg['cas_protocol'], $authCfg['cas_host'], $authCfg['cas_port'], $authCfg['cas_context']);
		phpCAS::setNoCasServerValidation();
		phpCAS::logoutWithRedirectService(TL_BASE_HREF);
	}
}
