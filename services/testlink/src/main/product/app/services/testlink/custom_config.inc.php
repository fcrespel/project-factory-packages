<?php
/*
 * TestLink Custom Configuration
 * By Fabien CRESPEL <fabien@crespel.net>
 * Last updated: 2013-03-02
 */


// ----------------------------------------------------------------------------
/* [LOCALIZATION] */

/** @var string Default localization for users */
// The value must be available in $g_locales (see cfg/const.inc.php).
// Note: An attempt will be done to establish the default locale
// automatically using $_SERVER['HTTP_ACCEPT_LANGUAGE']
$tlCfg->default_language = 'fr_FR';


// ----------------------------------------------------------------------------
/* [LOGGING] */

/** 
 *  @var string Path to store logs - 
 *	for security reasons (see http://itsecuritysolutions.org/2012-08-13-TestLink-1.9.3-multiple-vulnerabilities/)
 *	put it out of reach via web or configure access denied.
 */
$tlCfg->log_path = '@{package.log}/';


// ----------------------------------------------------------------------------
/* [SMTP] */

// SMTP server Configuration ("localhost" is enough in the most cases)
$g_smtp_host          = 'localhost';  # SMTP server MUST BE configured  

# Configure using custom_config.inc.php
$g_tl_admin_email     = '@{root.user}@@{product.domain}'; # for problem/error notification 
$g_from_email         = 'testlink@@{product.domain}';  # email sender
$g_return_path_email  = '@{root.user}@@{product.domain}';


// ----------------------------------------------------------------------------
/* [User Authentication] */

/**
 * Login authentication method:
 * 	'MD5' => use password stored on db
 *	'LDAP' => use password from LDAP Server
 */
$tlCfg->authentication['method'] = 'LDAP';

/** LDAP authentication credentials */
$tlCfg->authentication['ldap_server'] = '@{ldap.host}';
$tlCfg->authentication['ldap_port'] = '@{ldap.port}';
$tlCfg->authentication['ldap_version'] = '3';
$tlCfg->authentication['ldap_root_dn'] = '@{ldap.base.dn}';
$tlCfg->authentication['ldap_organization']	= '(objectclass=@{ldap.user.class})';
$tlCfg->authentication['ldap_uid_field'] = '@{ldap.user.rdn.attr}';
$tlCfg->authentication['ldap_firstname_field'] = '@{ldap.user.firstname.attr}';
$tlCfg->authentication['ldap_lastname_field'] = '@{ldap.user.lastname.attr}';
$tlCfg->authentication['ldap_mail_field'] = '@{ldap.user.mail.attr}';
$tlCfg->authentication['ldap_bind_dn'] = '@{ldap.root.dn}';
$tlCfg->authentication['ldap_bind_passwd'] = '%{LDAP_ROOT_PASSWORD}';
$tlCfg->authentication['ldap_tls'] = false; // true -> use tls

/** CAS authentication configuration */
$tlCfg->authentication['SSO_enabled'] = @{cas.enabled};
$tlCfg->authentication['SSO_method'] = 'CAS';
$tlCfg->authentication['cas_host'] = '@{product.domain}';
$tlCfg->authentication['cas_port'] = @{cas.port};
$tlCfg->authentication['cas_context'] = '@{cas.context}';
$tlCfg->authentication['cas_protocol'] = 'S1'; // 1.0, 2.0 or S1 (for SAML 1.1)
$tlCfg->authentication['cas_logout_requests_enabled'] = true;
$tlCfg->authentication['cas_logout_requests_servers'] = array('@{product.domain}', 'localhost');
$tlCfg->authentication['cas_onthefly_registration'] = true;
$tlCfg->authentication['cas_firstname_attribute'] = '@{cas.attr.firstname}';
$tlCfg->authentication['cas_lastname_attribute'] = '@{cas.attr.lastname}';
$tlCfg->authentication['cas_mail_attribute'] = '@{cas.attr.mail}';

/** Enable/disable Users to create accounts on login page */
$tlCfg->user_self_signup = false;


// --------------------------------------------------------------------------------------
/* [API] */

/** XML-RPC API availability (disabled by default) */
$tlCfg->api->enabled = true;


// --------------------------------------------------------------------------------------
/* [GUI LAYOUT] */

/** GUI themes (base for CSS and images)- modify if you create own one */
$tlCfg->theme_dir = 'gui/themes/projectfactory/';

/** Dir for compiled templates */
$tlCfg->temp_dir = '@{package.data}/templates_c/';

/** Login page could show an informational text */
$tlCfg->login_info = "<p>Si vous disposez déjà d'un compte, connectez-vous avec vos identifiants ci-dessus.<br/>" . 
                     "Pour obtenir un compte, contactez un administrateur de la plateforme.</p>" . 
					 "<p>L'accès à certains projets peut nécessiter des autorisations spécifiques, à demander au responsable du projet.</p>";

/**
 * Display name definition (used to build a human readable display name for users)
 * Example of values:
 * 		'%first% %last%'          -> John Cook
 * 		'%last%, %first%'          -> Cook John
 * 		'%first% %last% %login%'    -> John Cook [ux555]
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

// Set display order of uploaded files - BUGID 1086
$g_attachments->order_by = " ORDER BY id ASC ";
