--
-- Project Factory Setup - TestLink
-- By Fabien CRESPEL <fabien@crespel.net>
--

-- Change default admin user to root
UPDATE `users` SET
`login` = '@{root.user}',
`password` = '%{ROOT_PASSWORD_MD5}',
`email` = '@{root.user}@@{product.domain}',
`first` = 'System',
`last` = 'Administrator',
`locale` = 'fr_FR'
WHERE `login` = 'admin';

-- Add bot user
INSERT INTO `users` (`login`, `password`, `role_id`, `email`, `first`, `last`, `locale`, `active`, `script_key`)
VALUES ('@{bot.user}', '%{BOT_PASSWORD_MD5}', 8, '@{bot.user}@@{product.domain}', 'System', 'Bot', 'en_GB', 1, '%{BOT_PASSWORD_MD5}');

-- Configure Redmine as an issue tracker
INSERT INTO `issuetrackers` (`id`, `name`, `type`, `cfg`) VALUES
(1, 'Redmine', 15, '<issuetracker>\r\n<apikey>%{BOT_PASSWORD_MD5}</apikey>\r\n<uribase>@{product.scheme}://@{product.domain}/redmine/</uribase>\r\n<uriview>@{product.scheme}://@{product.domain}/redmine/issues/</uriview>\r\n</issuetracker>');
