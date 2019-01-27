<?php
/*
 * TestLink Custom Configuration
 * By Fabien CRESPEL <fabien@crespel.net>
 */


// ----------------------------------------------------------------------------
/* [LOCALIZATION] */

/** @var string Default localization for users */
// The value must be available in $$tlCfg->locales (see cfg/const.inc.php).
// Note: An attempt will be done to establish the default locale
// automatically using $_SERVER['HTTP_ACCEPT_LANGUAGE']
$tlCfg->default_language = 'fr_FR';


// ----------------------------------------------------------------------------
/* [LOGGING] */

/** 
 *  @var string Path to store logs - 
 *  for security reasons (see http://itsecuritysolutions.org/2012-08-13-TestLink-1.9.3-multiple-vulnerabilities/)
 *  put it out of reach via web or configure access denied.
 */
$tlCfg->log_path = '@{package.log}/';


// ----------------------------------------------------------------------------
/* [SMTP] */

/**
 * @var string SMTP server name or IP address ("localhost" should work in the most cases)
 * Configure using custom_config.inc.php
 * @uses lib/functions/email_api.php
 */
$g_smtp_host        = '@{smtp.host}';  # SMTP server MUST BE configured

# Configure using custom_config.inc.php
$g_tl_admin_email     = '@{root.user}@@{product.domain}'; # for problem/error notification 
$g_from_email         = 'testlink@@{product.domain}';  # email sender
$g_return_path_email  = '@{root.user}@@{product.domain}';

/**
 * The smtp port to use.  The typical SMTP ports are 25 and 587.  The port to use
 * will depend on the SMTP server configuration and hence others may be used.
 * @global int $g_smtp_port
 */
$g_smtp_port = @{smtp.port};


// ----------------------------------------------------------------------------
/* [User Authentication] */

/* Default Authentication method */
$tlCfg->authentication['method'] = 'LDAP';

/**
 * Single Sign On authentication
 *
 * SSO_method: CLIENT_CERTIFICATE, tested with Apache Webserver
 * SSP_method: WEBSERVER_VAR, tested with Apache and Shibboleth Service Provider.
 * SSO_method: CAS, provided by Project Factory 
 */
$tlCfg->authentication['SSO_enabled'] = @{cas.enabled};
$tlCfg->authentication['SSO_logout_destination'] = '@{cas.url}logout?service=@{product.scheme}://@{product.domain}/testlink/';
$tlCfg->authentication['SSO_method'] = 'CAS';
$tlCfg->authentication['cas_host'] = '@{cas.host}';
$tlCfg->authentication['cas_port'] = @{cas.port};
$tlCfg->authentication['cas_context'] = '@{cas.context}';
$tlCfg->authentication['cas_protocol'] = 'S1'; // 1.0, 2.0 or S1 (for SAML 1.1)
$tlCfg->authentication['cas_logout_requests_enabled'] = true;
$tlCfg->authentication['cas_logout_requests_servers'] = array('@{product.domain}', 'localhost');
$tlCfg->authentication['cas_onthefly_registration'] = true;
$tlCfg->authentication['cas_firstname_attribute'] = '@{cas.attr.firstname}';
$tlCfg->authentication['cas_lastname_attribute'] = '@{cas.attr.lastname}';
$tlCfg->authentication['cas_mail_attribute'] = '@{cas.attr.mail}';

/**
 * LDAP authentication credentials, Multiple LDAP Servers can be used. 
 * User will be authenticaded against each server (one after other using array index order)
 * till authentication succeed or all servers have been used.
 */
$tlCfg->authentication['ldap'] = array();
$tlCfg->authentication['ldap'][1]['ldap_server'] = '@{ldap.host}';
$tlCfg->authentication['ldap'][1]['ldap_port'] = '@{ldap.port}';
$tlCfg->authentication['ldap'][1]['ldap_version'] = '3';
$tlCfg->authentication['ldap'][1]['ldap_root_dn'] = '@{ldap.base.dn}';
$tlCfg->authentication['ldap'][1]['ldap_organization']	= '(objectclass=@{ldap.user.class})';
$tlCfg->authentication['ldap'][1]['ldap_uid_field'] = '@{ldap.user.rdn.attr}';
$tlCfg->authentication['ldap'][1]['ldap_firstname_field'] = '@{ldap.user.firstname.attr}';
$tlCfg->authentication['ldap'][1]['ldap_lastname_field'] = '@{ldap.user.lastname.attr}';
$tlCfg->authentication['ldap'][1]['ldap_mail_field'] = '@{ldap.user.mail.attr}';
$tlCfg->authentication['ldap'][1]['ldap_bind_dn'] = '@{ldap.root.dn}';
$tlCfg->authentication['ldap'][1]['ldap_bind_passwd'] = '%{LDAP_ROOT_PASSWORD}';
$tlCfg->authentication['ldap'][1]['ldap_tls'] = false; // true -> use tls
$tlCfg->authentication['ldap_automatic_user_creation'] = false;

/** Enable/disable Users to create accounts on login page */
$tlCfg->user_self_signup = false;


// --------------------------------------------------------------------------------------
/* [API] */

/** XML-RPC API availability - do less than promised ;) 
    FALSE => user are not able to generate and set his/her API key.
    XML-RPC server do not check this config in order to answer or not a call.
 */
$tlCfg->api->enabled = true;


// --------------------------------------------------------------------------------------
/* [GUI LAYOUT] */

/**
 * Display name definition (used to build a human readable display name for users)
 * Example of values:
 *    '%first% %last%'          -> John Cook
 *    '%last%, %first%'          -> Cook John
 *    '%first% %last% %login%'    -> John Cook [ux555]
 **/
$tlCfg->username_format = '%first% %last% [%login%]';


// ----------------------------------------------------------------------------
/* [GENERATED DOCUMENTATION] */

/**
 * Texts and settings for printed documents
 * Image is expected in directory <testlink_root>/gui/themes/<your_theme>/images/
 * Leave text values empty if you would like to hide parameters.
 */
$tlCfg->document_generator->company_name = '';
$tlCfg->document_generator->company_copyright = '';
$tlCfg->document_generator->confidential_msg = '';


// ----------------------------------------------------------------------------
/* [ATTACHMENTS] */

// Set display order of uploaded files
$g_attachments->order_by = " ORDER BY id ASC ";

/**
 * TL_REPOSITORY_TYPE_FS: the where the filesystem repository should be located
 * We recommend to change the directory for security reason.
 * (see http://itsecuritysolutions.org/2012-08-13-TestLink-1.9.3-multiple-vulnerabilities/)
 * Put it out of reach via web or configure access denied.
 *
 **/
$g_repositoryPath = '@{package.data}/upload_area/';

// the maximum allowed file size for each repository entry, default 1MB.
// Also check your PHP settings (default is usually 2MBs)
$tlCfg->repository_max_filesize = 10; //MB
