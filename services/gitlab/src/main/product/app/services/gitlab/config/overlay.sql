--
-- Project Factory Setup - GitLab
-- By Fabien CRESPEL <fabien@crespel.net>
--

-- Root user
UPDATE `users`
SET `email` = '@{root.user}@@{product.domain}',
`name` = 'System Administrator',
`theme_id` = 1,
`authentication_token` = '%{ROOT_PASSWORD_MD5}',
`username` = '@{root.user}',
`password_expires_at` = NULL,
`notification_email` = '@{root.user}@@{product.domain}',
`password_automatically_set` = 1
WHERE `id` = 1;

-- Bot user
REPLACE INTO `users` (`id`, `email`, `encrypted_password`, `created_at`, `updated_at`, `name`, `admin`, `projects_limit`, `authentication_token`, `username`, `can_create_group`, `can_create_team`, `state`, `confirmed_at`, `notification_email`, `password_automatically_set`) VALUES
(2, '@{bot.user}@@{product.domain}', '$2a$10$Nprk4jXZzKbHaFLNtG64auCOe4OMCjYe/iNwnkTcTvmmfPjvXyRmO', SYSDATE(), SYSDATE(), 'System Bot', 1, 0, '%{BOT_PASSWORD_MD5}', '@{bot.user}', 0, 0, 'active', SYSDATE(), '@{bot.user}@@{product.domain}', 1);

-- Identities
REPLACE INTO `identities` (`id`, `extern_uid`, `provider`, `user_id`, `created_at`, `updated_at`) VALUES
(1, 'root', CASE '@{cas.enabled}' WHEN 'true' THEN 'cas3' WHEN '1' THEN 'cas3' ELSE 'ldap' END, 1, SYSDATE(), SYSDATE()),
(2, 'bot', CASE '@{cas.enabled}' WHEN 'true' THEN 'cas3' WHEN '1' THEN 'cas3' ELSE 'ldap' END, 2, SYSDATE(), SYSDATE());

UPDATE `identities`
SET `provider` = 'cas3'
WHERE `provider` = 'cas';

-- Settings
UPDATE `application_settings`
SET `default_projects_limit` = 100,
`signup_enabled` = 0,
`signin_enabled` = 0,
`version_check_enabled` = 0,
`default_group_visibility` = 0;

UPDATE `application_settings`
SET `after_sign_out_path` = '@{cas.url}logout?service=@{product.scheme}%3A%2F%2F@{product.domain}%2Fgitlab%2F'
WHERE '@{cas.enabled}' = 'true' OR '@{cas.enabled}' = '1';
