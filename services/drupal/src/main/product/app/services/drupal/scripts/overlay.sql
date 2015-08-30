CREATE TABLE IF NOT EXISTS `cas_user` (
  `aid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key: Unique authmap ID.',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT 'User’s users.uid.',
  `cas_name` varchar(128) NOT NULL DEFAULT '' COMMENT 'Unique authentication name.',
  PRIMARY KEY (`aid`),
  UNIQUE KEY `cas_name` (`cas_name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Stores CAS authentication mapping.' ;

INSERT INTO `cas_user` (`uid`, `cas_name`) VALUES
(1, '@{root.user}');


CREATE TABLE IF NOT EXISTS `ldap_servers` (
  `sid` varchar(20) NOT NULL,
  `numeric_sid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary ID field for the table.  Only used internally.',
  `name` varchar(255) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '0',
  `ldap_type` varchar(20) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `port` int(11) DEFAULT '389',
  `tls` tinyint(4) DEFAULT '0',
  `followrefs` tinyint(4) DEFAULT '0',
  `bind_method` smallint(6) DEFAULT '0',
  `binddn` varchar(511) DEFAULT NULL,
  `bindpw` varchar(255) DEFAULT NULL,
  `basedn` text,
  `user_attr` varchar(255) DEFAULT NULL,
  `account_name_attr` varchar(255) DEFAULT '',
  `mail_attr` varchar(255) DEFAULT NULL,
  `mail_template` varchar(255) DEFAULT NULL,
  `picture_attr` varchar(255) DEFAULT NULL,
  `unique_persistent_attr` varchar(64) DEFAULT NULL,
  `unique_persistent_attr_binary` tinyint(4) DEFAULT '0',
  `user_dn_expression` varchar(255) DEFAULT NULL,
  `ldap_to_drupal_user` varchar(1024) DEFAULT NULL,
  `testing_drupal_username` varchar(255) DEFAULT NULL,
  `testing_drupal_user_dn` varchar(255) DEFAULT NULL,
  `grp_unused` tinyint(4) DEFAULT '0',
  `grp_object_cat` varchar(64) DEFAULT NULL,
  `grp_nested` tinyint(4) DEFAULT '0',
  `grp_user_memb_attr_exists` tinyint(4) DEFAULT '0',
  `grp_user_memb_attr` varchar(255) DEFAULT NULL,
  `grp_memb_attr` varchar(255) DEFAULT NULL,
  `grp_memb_attr_match_user_attr` varchar(255) DEFAULT NULL,
  `grp_derive_from_dn` tinyint(4) DEFAULT '0',
  `grp_derive_from_dn_attr` varchar(255) DEFAULT NULL,
  `grp_test_grp_dn` varchar(255) DEFAULT NULL,
  `grp_test_grp_dn_writeable` varchar(255) DEFAULT NULL,
  `search_pagination` tinyint(4) DEFAULT '0',
  `search_page_size` mediumint(9) DEFAULT '1000',
  `weight` int(11) DEFAULT '0',
  PRIMARY KEY (`numeric_sid`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

INSERT INTO `ldap_servers` (`sid`, `numeric_sid`, `name`, `status`, `ldap_type`, `address`, `port`, `tls`, `followrefs`, `bind_method`, `binddn`, `bindpw`, `basedn`, `user_attr`, `account_name_attr`, `mail_attr`, `mail_template`, `picture_attr`, `unique_persistent_attr`, `unique_persistent_attr_binary`, `user_dn_expression`, `ldap_to_drupal_user`, `testing_drupal_username`, `testing_drupal_user_dn`, `grp_unused`, `grp_object_cat`, `grp_nested`, `grp_user_memb_attr_exists`, `grp_user_memb_attr`, `grp_memb_attr`, `grp_memb_attr_match_user_attr`, `grp_derive_from_dn`, `grp_derive_from_dn_attr`, `grp_test_grp_dn`, `grp_test_grp_dn_writeable`, `search_pagination`, `search_page_size`, `weight`) VALUES
('local', 1, 'Local', 1, 'default', '@{ldap.host}', @{ldap.port}, 0, 0, 1, '@{ldap.root.dn}', '%{LDAP_ROOT_PASSWORD}', '%{LDAP_BASE_DN_ARRAY}', '@{ldap.user.rdn.attr}', '', '@{ldap.user.mail.attr}', '', '', '', 0, '@{ldap.user.rdn.attr}=%username,@{ldap.users.rdn},%basedn', '', '@{bot.user}', '@{ldap.user.rdn.attr}=@{bot.user},@{ldap.users.dn}', 0, '@{ldap.group.class}', 0, 0, '@{ldap.user.memberof.attr}', '@{ldap.group.member.attr}', 'dn', 0, '', '@{ldap.group.rdn.attr}=@{product.group.users},@{ldap.groups.dn}', '', 0, 1000, 0);


CREATE TABLE IF NOT EXISTS `ldap_authorization` (
  `numeric_consumer_conf_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary ID field for the table.  Only used internally.',
  `sid` varchar(20) NOT NULL,
  `consumer_type` varchar(20) NOT NULL,
  `consumer_module` varchar(30) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `only_ldap_authenticated` tinyint(4) NOT NULL DEFAULT '1',
  `use_first_attr_as_groupid` tinyint(4) NOT NULL DEFAULT '0',
  `mappings` mediumtext,
  `use_filter` tinyint(4) NOT NULL DEFAULT '1',
  `synch_to_ldap` tinyint(4) NOT NULL DEFAULT '0',
  `synch_on_logon` tinyint(4) NOT NULL DEFAULT '0',
  `revoke_ldap_provisioned` tinyint(4) NOT NULL DEFAULT '0',
  `create_consumers` tinyint(4) NOT NULL DEFAULT '0',
  `regrant_ldap_provisioned` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`numeric_consumer_conf_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Data used to map users ldap entry to authorization rights.' ;

INSERT INTO `ldap_authorization` (`numeric_consumer_conf_id`, `sid`, `consumer_type`, `consumer_module`, `status`, `only_ldap_authenticated`, `use_first_attr_as_groupid`, `mappings`, `use_filter`, `synch_to_ldap`, `synch_on_logon`, `revoke_ldap_provisioned`, `create_consumers`, `regrant_ldap_provisioned`) VALUES
(1, 'local', 'drupal_role', 'ldap_authorization_drupal_role', 1, 0, 1, '%{LDAP_AUTHORIZATION_MAPPINGS}', 1, 0, 1, 1, 1, 1);
