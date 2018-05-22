--
-- Project Factory Setup - SonarQube overlay
-- By Fabien CRESPEL <fabien@crespel.net>
--

UPDATE `users` SET `active` = 0 WHERE `id` = 1;

INSERT INTO `users` (`id`, `login`, `name`, `email`, `crypted_password`, `salt`, `active`, `created_at`, `updated_at`, `scm_accounts`, `external_identity`, `external_identity_provider`, `user_local`, `is_root`, `onboarded`) VALUES
(2, '@{root.user}', 'System Administrator', '@{root.user}@@{product.domain}', '%{ROOT_PASSWORD_SALTED}', '%{ROOT_PASSWORD_SALT}', 1, UNIX_TIMESTAMP() * 1000, UNIX_TIMESTAMP() * 1000, NULL, '@{root.user}', 'sonarqube', 0, 0, 1),
(3, '@{bot.user}', 'System Bot', '@{bot.user}@@{product.domain}', '%{BOT_PASSWORD_SALTED}', '%{BOT_PASSWORD_SALT}', 1, UNIX_TIMESTAMP() * 1000, UNIX_TIMESTAMP() * 1000, NULL, '@{bot.user}', 'sonarqube', 0, 0, 1);


INSERT INTO `user_tokens` (`login`, `name`, `token_hash`, `created_at`) VALUES
('@{bot.user}', '@{bot.user}', '%{BOT_TOKEN_SHA384}', UNIX_TIMESTAMP() * 1000);


INSERT INTO `groups` (`id`, `name`, `description`, `created_at`, `updated_at`, `organization_uuid`) VALUES
(3, '@{product.group.admins}', '@{product.name} Admins', SYSDATE(), SYSDATE(), 'AWOEsZN9_iellEQuyHxC'),
(4, '@{product.group.supervisors}', '@{product.name} Supervisors', SYSDATE(), SYSDATE(), 'AWOEsZN9_iellEQuyHxC'),
(5, '@{product.group.users}', '@{product.name} Users', SYSDATE(), SYSDATE(), 'AWOEsZN9_iellEQuyHxC');


INSERT INTO `groups_users` (`user_id`, `group_id`) VALUES
(2, 2),
(2, 3),
(2, 4),
(2, 5),
(3, 2),
(3, 5);


DELETE FROM `group_roles` WHERE `group_id` IS NULL;

INSERT INTO `group_roles` (`group_id`, `resource_id`, `role`, `organization_uuid`) VALUES
(2, NULL, 'provisioning', 'AWOEsZN9_iellEQuyHxC'),
(2, NULL, 'scan', 'AWOEsZN9_iellEQuyHxC'),
(3, NULL, 'admin', 'AWOEsZN9_iellEQuyHxC'),
(3, NULL, 'gateadmin', 'AWOEsZN9_iellEQuyHxC'),
(3, NULL, 'profileadmin', 'AWOEsZN9_iellEQuyHxC'),
(3, NULL, 'provisioning', 'AWOEsZN9_iellEQuyHxC'),
(5, NULL, 'provisioning', 'AWOEsZN9_iellEQuyHxC'),
(5, NULL, 'scan', 'AWOEsZN9_iellEQuyHxC');


INSERT INTO `properties` (`prop_key`, `resource_id`, `user_id`, `is_empty`, `text_value`, `clob_value`, `created_at`) VALUES
('email.from', NULL, NULL, 0, 'sonarqube@@{product.domain}', NULL, UNIX_TIMESTAMP() * 1000),
('email.smtp_host.secured', NULL, NULL, 0, '@{smtp.host}', NULL, UNIX_TIMESTAMP() * 1000),
('email.smtp_port.secured', NULL, NULL, 0, '@{smtp.port}', NULL, UNIX_TIMESTAMP() * 1000),
('sonar.core.serverBaseURL', NULL, NULL, 0, '@{product.scheme}://@{product.domain}/sonarqube/', NULL, UNIX_TIMESTAMP() * 1000);
