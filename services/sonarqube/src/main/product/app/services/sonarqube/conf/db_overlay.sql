--
-- Project Factory Setup - SonarQube overlay
-- By Fabien CRESPEL <fabien@crespel.net>
--

UPDATE `users` SET `active` = 0 WHERE `id` = 1;

INSERT INTO `users` (`id`, `login`, `name`, `email`, `crypted_password`, `salt`, `created_at`, `updated_at`, `remember_token`, `remember_token_expires_at`, `active`) VALUES
(2, '@{root.user}', 'System Administrator', '@{root.user}@@{product.domain}', '%{ROOT_PASSWORD_SALTED}', '%{ROOT_PASSWORD_SALT}', SYSDATE(), SYSDATE(), NULL, NULL, 1),
(3, '@{bot.user}', 'System Bot', '@{bot.user}@@{product.domain}', '%{BOT_PASSWORD_SALTED}', '%{BOT_PASSWORD_SALT}', SYSDATE(), SYSDATE(), NULL, NULL, 1);


INSERT INTO `groups` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(3, '@{product.group.admins}', '@{product.name} Admins', SYSDATE(), SYSDATE()),
(4, '@{product.group.supervisors}', '@{product.name} Supervisors', SYSDATE(), SYSDATE()),
(5, '@{product.group.users}', '@{product.name} Users', SYSDATE(), SYSDATE());


INSERT INTO `groups_users` (`user_id`, `group_id`) VALUES
(2, 3),
(2, 4),
(2, 5),
(3, 2),
(3, 5);


DELETE FROM `group_roles` WHERE `group_id` IS NULL;

INSERT INTO `group_roles` (`group_id`, `resource_id`, `role`) VALUES
(2, NULL, 'scan'),
(2, NULL, 'dryRunScan'),
(3, NULL, 'admin'),
(3, NULL, 'profileadmin'),
(3, NULL, 'shareDashboard'),
(3, NULL, 'provisioning'),
(5, NULL, 'scan'),
(5, NULL, 'dryRunScan');


INSERT INTO `properties` (`prop_key`, `resource_id`, `text_value`, `user_id`) VALUES
('sonar.pagedecoration.header', NULL, '<script type="text/javascript" src="/portal/toolbar.php?tab=sonarqube&amp;format=js"></script>', NULL),
('sonar.pagedecoration.style', NULL, '<link rel="stylesheet" href="/portal/themes/default/css/sonarqube.css" />', NULL),
('sonar.redmine.api-access-key', NULL, '%{BOT_PASSWORD_MD5}', NULL),
('sonar.redmine.url', NULL, '@{product.scheme}://@{product.domain}/redmine/', NULL);
