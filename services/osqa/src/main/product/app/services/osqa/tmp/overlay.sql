--
-- Project Factory Setup - OSQA
-- By Fabien CRESPEL <fabien@crespel.net>
--


-- Custom CSS

INSERT INTO `forum_keyvalue` (`key`, `value`)
VALUES ('USE_CUSTOM_CSS', 'eJzzNDDk0gMAAwcA4w==');

INSERT INTO `forum_keyvalue` (`key`, `value`)
VALUES ('CUSTOM_CSS', 'T[str]@import "/portal/themes/current/css/osqa.css";');


-- Custom head elements

INSERT INTO `forum_keyvalue` (`key`, `value`)
VALUES ('USE_CUSTOM_HEAD', 'eJzzNDDk0gMAAwcA4w==');

INSERT INTO `forum_keyvalue` (`key`, `value`)
VALUES ('CUSTOM_HEAD', 'T[str]<script type="text/javascript" src="/portal/toolbar.php?tab=osqa&amp;format=js"></script>');


-- Sidebar

INSERT INTO `forum_keyvalue` (`key`, `value`)
VALUES ('APP_INTRO', 'eJwljDsOwkAMRPucYqhoEIg+yhEo6VesFSytYmN7U3DalMktsEQzGr35PEedHuf34Rz0hRbHBhUnQyXHp5MHy+KoJeVFAenB7YJ0GwrXLK6SibS2z9lOGiZ9Td4K7NAcU8JG3Ry8BJnJXP6np/Gm06D34foD4L8zRQ==');

INSERT INTO `forum_keyvalue` (`key`, `value`)
VALUES ('QUESTION_TITLE_TIPS', 'eJxFTssKwjAQvAv+w5wDLfUTPCgIPRQsngRZ0hUCbbYmG0HpD9evMPVgL8Ow89i5FDCmkchvJM94JI7qxIM9Ao2jBAU92aInWBmG5CnpjGnfNLf21NaHyZjtNVVVRQVqhjoNjE6c4rOwKCniLmHIx7W9/EeOkoJ3cXlPP8yublZyfVxNZ3llxfbkAljzDm9dLDfjblN+ASN5QjE=');

INSERT INTO `forum_keyvalue` (`key`, `value`)
VALUES ('QUESTION_TAG_TIPS', 'eJxdj0GKwkAQRfeCd/i7gaAhcwQHVISJgjOKCyE0pNAakm7TVZWVh3XpMWxkVHBV/PfrQdV2jG8SqDsIJHhFnVIbVNAZg33NnVHCDSHL9HhtKW2gcakmUQ4+y/Lh3oqicGMsGoHjmmK4GymYxjQu0Bisp4g+JPB0X+bGvyhOZArXB474M+ns44LzbLUuq3Kyq5ab8mu6rlaz6ncy/znfLx+hdSyoAyvI/6vO0h/s5eEulu9uPjh9DvIb5MRZCA==');

INSERT INTO `forum_keyvalue` (`key`, `value`)
VALUES ('SIDEBAR_UPPER_SHOW', 'eJzzNDDg0gMAAwQA4g==');

INSERT INTO `forum_keyvalue` (`key`, `value`)
VALUES ('SIDEBAR_LOWER_TEXT', 'eJxdj7FuwkAQRHsk/mEkCoMlzk5LRx8pIKQ0geJkL3DCulvf3uFvzl9kbSgg1Whnn3ZmvxcL7LosaAvnz0EgOeLrsN/Oj7mua/uU0QFJQleEnFyHwOTXEnJsCC2hz7p0wUsVf1mFRC2nx5hDTASlhOLdNWTeD38SfspSnDJtMaaU5Wl5TYk3VTUMgwnSW+MpVSuQpk/04G4O/1n1XmEJPmkxQSR51BSMxVVYR5CHZY7k26jJ9m59sheavm80aHrSzPhjZv4ARuhiXg==');


-- Logo and favicon

INSERT INTO `forum_keyvalue` (`key`, `value`)
VALUES ('APP_LOGO', 'T[str]/osqa/upfiles/logo.png');

INSERT INTO `forum_keyvalue` (`key`, `value`)
VALUES ('APP_FAVICON', 'T[str]/osqa/m/default/media/images/favicon.ico');


-- Email settings

INSERT INTO `forum_keyvalue` (`key`, `value`)
VALUES ('EMAIL_HOST', 'T[str]localhost');

INSERT INTO `forum_keyvalue` (`key`, `value`)
VALUES ('EMAIL_SUBJECT_PREFIX', 'T[str][OSQA]');

INSERT INTO `forum_keyvalue` (`key`, `value`)
VALUES ('DEFAULT_FROM_EMAIL', 'T[str]osqa@@{product.domain}');


-- Upload settings
INSERT INTO `forum_keyvalue` (`key`, `value`)
VALUES ('UPFILES_ALIAS', 'T[str]/osqa/upfiles/');


-- LDAP
INSERT INTO `forum_keyvalue` (`key`, `value`)
VALUES ('LDAP_SERVER', 'ldap://@{ldap.host}:@{ldap.port}');

INSERT INTO `forum_keyvalue` (`key`, `value`)
VALUES ('LDAP_BASE_DN', '@{ldap.users.dn}');

INSERT INTO `forum_keyvalue` (`key`, `value`)
VALUES ('LDAP_USER_MASK', '@{ldap.user.rdn.attr}=%s');

INSERT INTO `forum_keyvalue` (`key`, `value`)
VALUES ('LDAP_UID', '@{ldap.user.rdn.attr}');

INSERT INTO `forum_keyvalue` (`key`, `value`)
VALUES ('LDAP_NAME', '@{ldap.user.displayname.attr}');

INSERT INTO `forum_keyvalue` (`key`, `value`)
VALUES ('LDAP_MAIL', '@{ldap.user.mail.attr}');


-- CAS
INSERT INTO `forum_keyvalue` (`key`, `value`)
VALUES ('CAS_SERVER_URL', '@{cas.url}');

INSERT INTO `forum_keyvalue` (`key`, `value`)
VALUES ('CAS_PROTOCOL', 'cas3');

INSERT INTO `forum_keyvalue` (`key`, `value`)
VALUES ('CAS_ATTRIBUTE_NAME', 'displayName');

INSERT INTO `forum_keyvalue` (`key`, `value`)
VALUES ('CAS_ATTRIBUTE_EMAIL', 'mail');

INSERT INTO `forum_keyvalue` (`key`, `value`)
VALUES ('CAS_LOGOUT_REQUESTS_ENABLED', 'eJzzNDDk0gMAAwcA4w==');

INSERT INTO `forum_keyvalue` (`key`, `value`)
VALUES ('DEFAULT_AUTH_PROVIDER', 'cas');

INSERT INTO `forum_keyvalue` (`key`, `value`)
VALUES ('IMMEDIATE_LOGOUT', 'eJzzNDDk0gMAAwcA4w==');


-- Root user
INSERT INTO `auth_user` (`id`, `username`, `first_name`, `last_name`, `email`, `password`, `is_staff`, `is_active`, `is_superuser`, `last_login`, `date_joined`) VALUES
(1, '@{root.user}', '', '', '@{root.user}@@{product.domain}', '!', 1, 1, 1, SYSDATE(), SYSDATE());

INSERT INTO `forum_user` (`user_ptr_id`, `is_approved`, `email_isvalid`, `reputation`, `gold`, `silver`, `bronze`, `last_seen`, `real_name`, `website`, `location`, `date_of_birth`, `about`) VALUES
(1, 0, 1, 1, 0, 0, 0, SYSDATE(), 'System Administrator', '', '', NULL, '');

INSERT INTO `forum_subscriptionsettings` (`id`, `user_id`, `enable_notifications`, `member_joins`, `new_question`, `new_question_watched_tags`, `subscribed_questions`, `all_questions`, `all_questions_watched_tags`, `questions_viewed`, `notify_answers`, `notify_reply_to_comments`, `notify_comments_own_post`, `notify_comments`, `notify_accepted`, `send_digest`) VALUES
(1, 1, 1, 'n', 'n', 'i', 'i', 0, 0, 0, 1, 0, 1, 0, 0, 0);


-- Fulltext search
INSERT INTO `forum_keyvalue` (`key`, `value`)
VALUES ('MYSQL_FTS_INSTALLED', 'eJzzNDDk0gMAAwcA4w==');

INSERT INTO `forum_keyvalue` (`key`, `value`)
VALUES ('MYSQL_FTS_VERSION', 'T[int]4');
