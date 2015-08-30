--
-- Project Factory Setup - Redmine
-- By Fabien CRESPEL <fabien@crespel.net>
--

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

-- LDAP authentication
INSERT INTO `auth_sources` (`id`, `type`, `name`, `host`, `port`, `account`, `account_password`, `base_dn`, `attr_login`, `attr_firstname`, `attr_lastname`, `attr_mail`, `onthefly_register`, `tls`) VALUES
(1, 'AuthSourceLdap', 'Local LDAP', '@{ldap.host}', @{ldap.port}, '@{ldap.root.dn}', '%{LDAP_ROOT_PASSWORD}', '@{ldap.base.dn}', '@{ldap.user.rdn.attr}', '@{ldap.user.firstname.attr}', '@{ldap.user.lastname.attr}', '@{ldap.user.mail.attr}', 1, 0);

-- Root user
UPDATE `users`
SET `login` = '@{root.user}',
`hashed_password` = SHA1(CONCAT(`salt`, '%{ROOT_PASSWORD_SHA1}')),
`firstname` = 'System',
`lastname` = 'Admin',
`mail` = '@{root.user}@@{product.domain}',
`language` = '@{redmine.lang}',
`auth_source_id` = 1
WHERE `id` = 1;

-- Bot user
INSERT INTO `users` (`id`, `login`, `hashed_password`, `firstname`, `lastname`, `mail`, `admin`, `status`, `last_login_on`, `language`, `auth_source_id`, `created_on`, `updated_on`, `type`, `identity_url`, `mail_notification`, `salt`) VALUES
(4, '@{bot.user}', '', 'System', 'Bot', '@{bot.user}@@{product.domain}', 0, 1, NULL, '@{redmine.lang}', 1, SYSDATE(), SYSDATE(), 'User', NULL, 'only_my_events', NULL);

-- Bot API key
INSERT INTO `tokens` (`id`, `user_id`, `action`, `value`, `created_on`) VALUES
(1, 4, 'api', '%{BOT_PASSWORD_MD5}', SYSDATE());

-- Settings
INSERT INTO `settings` (`id`, `name`, `value`, `updated_on`) VALUES
(1, 'text_formatting', 'textile', SYSDATE()),
(2, 'protocol', 'http', SYSDATE()),
(3, 'repositories_encodings', '', SYSDATE()),
(4, 'host_name', '@{product.domain}/redmine', SYSDATE()),
(5, 'app_title', 'Redmine', SYSDATE()),
(6, 'welcome_text', '!>/redmine/images/redmine-logo.png!\r\n\r\nBienvenue sur l''outil de *gestion de projets Redmine*.\r\n\r\nPour *plus d''informations* sur cet outil :\r\n* "Vue d''ensemble des fonctionnalités":http://www.redmine.org/projects/redmine/wiki/Features (en anglais)\r\n* "Guide de l''utilisateur":http://www.redmine.org/projects/redmine/wiki/Guide (en anglais)\r\n* "Guide de l''utilisateur":http://www.redmine.org/projects/redmine/wiki/FrGuide (en français)', SYSDATE()),
(7, 'cache_formatted_text', '0', SYSDATE()),
(8, 'wiki_compression', '', SYSDATE()),
(9, 'per_page_options', '25,50,100', SYSDATE()),
(10, 'file_max_size_displayed', '512', SYSDATE()),
(11, 'feeds_limit', '15', SYSDATE()),
(12, 'activity_days_default', '30', SYSDATE()),
(13, 'attachment_max_size', '102400', SYSDATE()),
(14, 'diff_max_lines_displayed', '1500', SYSDATE()),
(15, 'date_format', '', SYSDATE()),
(16, 'ui_theme', 'projectfactory', SYSDATE()),
(17, 'gravatar_enabled', '0', SYSDATE()),
(18, 'user_format', 'firstname_lastname', SYSDATE()),
(19, 'start_of_week', '', SYSDATE()),
(20, 'gravatar_default', '', SYSDATE()),
(21, 'time_format', '', SYSDATE()),
(22, 'default_language', 'fr', SYSDATE()),
(23, 'openid', '0', SYSDATE()),
(24, 'rest_api_enabled', '1', SYSDATE()),
(25, 'password_min_length', '4', SYSDATE()),
(26, 'self_registration', '0', SYSDATE()),
(27, 'login_required', '0', SYSDATE()),
(28, 'lost_password', '0', SYSDATE()),
(29, 'autologin', '7', SYSDATE()),
(30, 'sequential_project_identifiers', '0', SYSDATE()),
(31, 'default_projects_public', '0', SYSDATE()),
(32, 'default_projects_modules', '--- \n- issue_tracking\n- time_tracking\n- news\n- documents\n- files\n- wiki\n- repository\n- boards\n- calendar\n- gantt\n- wiki_extensions\n', SYSDATE()),
(33, 'issue_group_assignment', '1', SYSDATE()),
(34, 'default_issue_start_date_to_creation_date', '1', SYSDATE()),
(35, 'issue_done_ratio', 'issue_field', SYSDATE()),
(36, 'issue_list_default_columns', '--- \n- tracker\n- status\n- priority\n- subject\n- assigned_to\n- updated_on\n- done_ratio\n', SYSDATE()),
(37, 'display_subprojects_issues', '1', SYSDATE()),
(38, 'gantt_items_limit', '500', SYSDATE()),
(39, 'issues_export_limit', '500', SYSDATE()),
(40, 'cross_project_issue_relations', '1', SYSDATE()),
(41, 'commit_fix_done_ratio', '100', SYSDATE()),
(42, 'enabled_scm', '--- \n- Subversion\n- Git\n', SYSDATE()),
(43, 'commit_fix_keywords', 'fixes,closes', SYSDATE()),
(44, 'commit_logtime_enabled', '0', SYSDATE()),
(45, 'sys_api_enabled', '1', SYSDATE()),
(46, 'sys_api_key', '%{REDMINE_SYS_API_KEY}', SYSDATE()),
(47, 'commit_ref_keywords', 'ref,refs,references,IssueID', SYSDATE()),
(48, 'commit_fix_status_id', '0', SYSDATE()),
(49, 'repository_log_display_limit', '100', SYSDATE()),
(50, 'autofetch_changesets', '1', SYSDATE()),
(51, 'emails_footer', 'You have received this notification because you have either subscribed to it, or are involved in it.\r\nTo change your notification preferences, please click here: @{product.scheme}://@{product.domain}/redmine/my/account', SYSDATE()),
(52, 'plain_text_mail', '0', SYSDATE()),
(53, 'emails_header', '', SYSDATE()),
(54, 'bcc_recipients', '1', SYSDATE()),
(55, 'default_notification_option', 'only_my_events', SYSDATE()),
(56, 'mail_from', 'redmine@@{product.domain}', SYSDATE()),
(57, 'notified_events', '--- \n- issue_added\n- issue_updated\n', SYSDATE()),
(58, 'unsubscribe', '0', SYSDATE()),
(59, 'thumbnails_size', '100', SYSDATE()),
(60, 'thumbnails_enabled', '1', SYSDATE()),
(61, 'plugin_redmine_testlinklink', '--- !map:HashWithIndifferentAccess \ndefault_planreport_summary: "1"\ntestlink_address: /testlink\ntestlink_version: "1.8"\ndefault_report_passfail: "1"\ndefault_report_summary: "1"\n', SYSDATE()),
(62, 'plugin_redmine_ldap_sync', '--- !map:ActiveSupport::HashWithIndifferentAccess \n1: !map:ActiveSupport::HashWithIndifferentAccess \n  group_fields_to_sync: []\n\n  group_search_filter: ""\n  dyngroups: ""\n  active: "1"\n  user_memberid: dn\n  user_groups: @{ldap.user.memberof.attr}\n  group_memberid: ""\n  member_group: ""\n  groups_base_dn: @{ldap.groups.dn}\n  group_ldap_attrs: !map:ActiveSupport::HashWithIndifferentAccess {}\n\n  user_ldap_attrs: !map:ActiveSupport::HashWithIndifferentAccess {}\n\n  group_membership: on_groups\n  account_flags: ""\n  nested_groups: ""\n  user_fields_to_sync: \n  - firstname\n  - lastname\n  - mail\n  fixed_group: ""\n  create_groups: "1"\n  groupname: @{ldap.group.rdn.attr}\n  account_disabled_test: ""\n  required_group: @{product.group.users}\n  parent_group: ""\n  admin_group: @{product.group.admins}\n  dyngroups_cache_ttl: ""\n  groupname_pattern: ""\n  groupid: distinguishedName\n  create_users: "1"\n  group_parentid: ""\n  class_group: @{ldap.group.class}\n  member: @{ldap.group.member.attr}\n  sync_on_login: user_fields_and_groups\n  class_user: @{ldap.user.class}\n', SYSDATE()),
(63, 'plugin_redmine_token_management', '--- !map:HashWithIndifferentAccess \nvar_lab_tokens_consumed: "Jetons consomm\\xC3\\xA9s"\nvar_lab_tokens_cost: "Co\\xC3\\xBBt du jeton"\nvar_lab_qualifying_period: "Dur\\xC3\\xA9e p\\xC3\\xA9riode probatoire(mois)"\nvar_lab_contract_start_date: "Date de d\\xC3\\xA9but du contrat"\nvar_lab_tokens_bought: "Jetons achet\\xC3\\xA9s"\n', SYSDATE()),
(64, 'plugin_redmine_hudson', '--- !map:ActiveSupport::HashWithIndifferentAccess \nquery_limit_builds_each_job: "100"\njob_description_format: hudson\nquery_limit_changesets_each_job: "100"\n', SYSDATE()),
(65, 'plugin_redmine_omniauth_cas', '--- !map:ActiveSupport::HashWithIndifferentAccess \nattr_lastname: sn\nonthefly_authsource_id: "1"\nonthefly_registration: "true"\ncas_server: @{cas.url}\nenabled: "@{cas.enabled}"\ncas_service_validate_url: ""\nattr_firstname: givenName\nreplace_redmine_login: "true"\nattr_mail: mail\nlabel_login_with_cas: ""\n', SYSDATE());

-- Hooks
INSERT INTO `hooks` (`id`, `hook`, `html_code`) VALUES
(1, 'view_layouts_base_html_head', '<script type="text/javascript" src="/portal/toolbar.php?tab=redmine&amp;format=js"></script>\r\n<script type="text/javascript" src="/portal/themes/current/js/redmine.js"></script>');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
