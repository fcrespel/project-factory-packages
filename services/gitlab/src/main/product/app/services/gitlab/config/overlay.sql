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
REPLACE INTO `users` (`id`, `email`, `encrypted_password`, `created_at`, `updated_at`, `name`, `admin`, `projects_limit`, `authentication_token`, `username`, `can_create_group`, `can_create_team`, `state`, `notification_level`, `confirmed_at`, `notification_email`, `password_automatically_set`) VALUES
(2, '@{bot.user}@@{product.domain}', '$2a$10$Nprk4jXZzKbHaFLNtG64auCOe4OMCjYe/iNwnkTcTvmmfPjvXyRmO', SYSDATE(), SYSDATE(), 'System Bot', 1, 0, '%{BOT_PASSWORD_MD5}', '@{bot.user}', 0, 0, 'active', 0, SYSDATE(), '@{bot.user}@@{product.domain}', 1);

-- Identities
REPLACE INTO `identities` (`id`, `extern_uid`, `provider`, `user_id`, `created_at`, `updated_at`) VALUES
(1, 'root', CASE '@{cas.enabled}' WHEN 'true' THEN 'cas' WHEN '1' THEN 'cas' ELSE 'ldap' END, 1, SYSDATE(), SYSDATE()),
(2, 'bot', CASE '@{cas.enabled}' WHEN 'true' THEN 'cas' WHEN '1' THEN 'cas' ELSE 'ldap' END, 2, SYSDATE(), SYSDATE());

-- Settings
REPLACE INTO `application_settings` (`id`, `default_projects_limit`, `signup_enabled`, `signin_enabled`, `gravatar_enabled`, `sign_in_text`, `created_at`, `updated_at`, `home_page_url`, `default_branch_protection`, `twitter_sharing_enabled`, `restricted_visibility_levels`, `version_check_enabled`, `max_attachment_size`, `default_project_visibility`, `default_snippet_visibility`, `restricted_signup_domains`, `user_oauth_applications`, `after_sign_out_path`, `session_expire_delay`) VALUES
(1, 100, 0, 0, 1, NULL, SYSDATE(), SYSDATE(), NULL, 2, 1, '--- []\n', 0, 10, 0, 0, '--- []\n', 1, CASE '@{cas.enabled}' WHEN 'true' THEN '@{cas.url}logout?service=@{product.scheme}%3A%2F%2F@{product.domain}%2Fgitlab%2F' WHEN '1' THEN '@{cas.url}logout?service=@{product.scheme}%3A%2F%2F@{product.domain}%2Fgitlab%2F' ELSE '' END, 10080);
