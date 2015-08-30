--
-- Project Factory Setup - SonarQube schema
-- By Fabien CRESPEL <fabien@crespel.net>
--

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;


CREATE TABLE IF NOT EXISTS `action_plans` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `name` varchar(200) COLLATE utf8_bin DEFAULT NULL,
  `description` varchar(1000) COLLATE utf8_bin DEFAULT NULL,
  `deadline` datetime DEFAULT NULL,
  `user_login` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `status` varchar(10) COLLATE utf8_bin DEFAULT NULL,
  `kee` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `I_ACTION_PLANS_PROJECT_ID` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `active_dashboards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dashboard_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `order_index` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `active_dashboards_userid` (`user_id`),
  KEY `active_dashboards_dashboardid` (`dashboard_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `active_rules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) NOT NULL,
  `rule_id` int(11) NOT NULL,
  `failure_level` int(11) NOT NULL,
  `inheritance` varchar(10) COLLATE utf8_bin DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_profile_rule_ids` (`profile_id`,`rule_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `active_rule_parameters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `active_rule_id` int(11) NOT NULL,
  `rules_parameter_id` int(11) NOT NULL,
  `value` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `rules_parameter_key` varchar(128) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `activities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `user_login` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `data_field` longtext COLLATE utf8_bin,
  `log_type` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `log_action` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `log_message` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `log_key` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `activities_log_key` (`log_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `authors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) NOT NULL,
  `login` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_author_logins` (`login`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `characteristics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kee` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `name` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `rule_id` int(11) DEFAULT NULL,
  `characteristic_order` int(11) DEFAULT NULL,
  `enabled` tinyint(1) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `root_id` int(11) DEFAULT NULL,
  `function_key` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `factor_value` decimal(30,20) DEFAULT NULL,
  `factor_unit` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `offset_value` decimal(30,20) DEFAULT NULL,
  `offset_unit` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `characteristics_enabled` (`enabled`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `dashboards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(256) COLLATE utf8_bin DEFAULT NULL,
  `description` varchar(1000) COLLATE utf8_bin DEFAULT NULL,
  `column_layout` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `shared` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_global` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `dependencies` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `from_snapshot_id` int(11) DEFAULT NULL,
  `from_resource_id` int(11) DEFAULT NULL,
  `to_snapshot_id` int(11) DEFAULT NULL,
  `to_resource_id` int(11) DEFAULT NULL,
  `dep_usage` varchar(30) COLLATE utf8_bin DEFAULT NULL,
  `dep_weight` int(11) DEFAULT NULL,
  `project_snapshot_id` int(11) DEFAULT NULL,
  `parent_dependency_id` bigint(20) DEFAULT NULL,
  `from_scope` varchar(3) COLLATE utf8_bin DEFAULT NULL,
  `to_scope` varchar(3) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `deps_from_sid` (`from_snapshot_id`),
  KEY `deps_to_sid` (`to_snapshot_id`),
  KEY `deps_prj_sid` (`project_snapshot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `duplications_index` (
  `project_snapshot_id` int(11) NOT NULL,
  `snapshot_id` int(11) NOT NULL,
  `hash` varchar(50) COLLATE utf8_bin NOT NULL,
  `index_in_file` int(11) NOT NULL,
  `start_line` int(11) NOT NULL,
  `end_line` int(11) NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `duplications_index_psid` (`project_snapshot_id`),
  KEY `duplications_index_sid` (`snapshot_id`),
  KEY `duplications_index_hash` (`hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(400) COLLATE utf8_bin DEFAULT NULL,
  `resource_id` int(11) DEFAULT NULL,
  `snapshot_id` int(11) DEFAULT NULL,
  `category` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `event_date` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `description` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `event_data` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `events_resource_id` (`resource_id`),
  KEY `events_snapshot_id` (`snapshot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `graphs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `snapshot_id` int(11) NOT NULL,
  `resource_id` int(11) NOT NULL,
  `format` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `perspective` varchar(30) COLLATE utf8_bin DEFAULT NULL,
  `version` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `root_vertex_id` varchar(30) COLLATE utf8_bin DEFAULT NULL,
  `data` longtext COLLATE utf8_bin,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `graphs_perspectives` (`snapshot_id`,`perspective`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `description` varchar(200) COLLATE utf8_bin DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `groups_users` (
  `user_id` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  UNIQUE KEY `GROUPS_USERS_UNIQUE` (`group_id`,`user_id`),
  KEY `index_groups_users_on_user_id` (`user_id`),
  KEY `index_groups_users_on_group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `group_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) DEFAULT NULL,
  `resource_id` int(11) DEFAULT NULL,
  `role` varchar(64) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_group_roles` (`group_id`,`resource_id`,`role`),
  KEY `group_roles_group` (`group_id`),
  KEY `group_roles_resource` (`resource_id`),
  KEY `group_roles_role` (`role`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `issues` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `kee` varchar(50) COLLATE utf8_bin NOT NULL,
  `component_id` int(11) NOT NULL,
  `root_component_id` int(11) DEFAULT NULL,
  `rule_id` int(11) DEFAULT NULL,
  `severity` varchar(10) COLLATE utf8_bin DEFAULT NULL,
  `manual_severity` tinyint(1) NOT NULL,
  `message` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `line` int(11) DEFAULT NULL,
  `effort_to_fix` decimal(30,20) DEFAULT NULL,
  `status` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `resolution` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `checksum` varchar(1000) COLLATE utf8_bin DEFAULT NULL,
  `reporter` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `assignee` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `author_login` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `action_plan_key` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `issue_attributes` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `issue_creation_date` datetime DEFAULT NULL,
  `issue_close_date` datetime DEFAULT NULL,
  `issue_update_date` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `technical_debt` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `issues_kee` (`kee`),
  KEY `issues_component_id` (`component_id`),
  KEY `issues_root_component_id` (`root_component_id`),
  KEY `issues_rule_id` (`rule_id`),
  KEY `issues_severity` (`severity`),
  KEY `issues_status` (`status`),
  KEY `issues_resolution` (`resolution`),
  KEY `issues_assignee` (`assignee`),
  KEY `issues_action_plan_key` (`action_plan_key`),
  KEY `issues_creation_date` (`issue_creation_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `issue_changes` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `kee` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `issue_key` varchar(50) COLLATE utf8_bin NOT NULL,
  `user_login` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `change_type` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `change_data` longtext COLLATE utf8_bin,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `issue_change_creation_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `issue_changes_kee` (`kee`),
  KEY `issue_changes_issue_key` (`issue_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `issue_filters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8_bin NOT NULL,
  `user_login` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `shared` tinyint(1) NOT NULL DEFAULT '0',
  `description` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `data` longtext COLLATE utf8_bin,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `issue_filters_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `issue_filter_favourites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_login` varchar(255) COLLATE utf8_bin NOT NULL,
  `issue_filter_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `issue_filter_favs_user` (`user_login`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `loaded_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kee` varchar(200) COLLATE utf8_bin DEFAULT NULL,
  `template_type` varchar(15) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `manual_measures` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `metric_id` int(11) NOT NULL,
  `resource_id` int(11) DEFAULT NULL,
  `value` decimal(30,20) DEFAULT NULL,
  `text_value` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `user_login` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `description` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `manual_measures_resource_id` (`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `measure_filters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8_bin NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `shared` tinyint(1) NOT NULL DEFAULT '0',
  `description` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `data` longtext COLLATE utf8_bin,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `measure_filters_name` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `measure_filter_favourites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `measure_filter_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `measure_filter_favs_userid` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `metrics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) COLLATE utf8_bin NOT NULL,
  `description` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `direction` int(11) NOT NULL DEFAULT '0',
  `domain` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `short_name` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `qualitative` tinyint(1) NOT NULL DEFAULT '0',
  `val_type` varchar(8) COLLATE utf8_bin DEFAULT NULL,
  `user_managed` tinyint(1) DEFAULT '0',
  `enabled` tinyint(1) DEFAULT '1',
  `origin` varchar(3) COLLATE utf8_bin DEFAULT NULL,
  `worst_value` decimal(30,20) DEFAULT NULL,
  `best_value` decimal(30,20) DEFAULT NULL,
  `optimized_best_value` tinyint(1) DEFAULT NULL,
  `hidden` tinyint(1) DEFAULT NULL,
  `delete_historical_data` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `metrics_unique_name` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data` longblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `permission_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8_bin NOT NULL,
  `kee` varchar(100) COLLATE utf8_bin NOT NULL,
  `description` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `key_pattern` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `perm_templates_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) DEFAULT NULL,
  `template_id` int(11) NOT NULL,
  `permission_reference` varchar(64) COLLATE utf8_bin NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `perm_templates_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `template_id` int(11) NOT NULL,
  `permission_reference` varchar(64) COLLATE utf8_bin NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) COLLATE utf8_bin DEFAULT NULL,
  `description` varchar(2000) COLLATE utf8_bin DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `scope` varchar(3) COLLATE utf8_bin DEFAULT NULL,
  `qualifier` varchar(10) COLLATE utf8_bin DEFAULT NULL,
  `kee` varchar(400) COLLATE utf8_bin DEFAULT NULL,
  `root_id` int(11) DEFAULT NULL,
  `language` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `copy_resource_id` int(11) DEFAULT NULL,
  `long_name` varchar(256) COLLATE utf8_bin DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `path` varchar(2000) COLLATE utf8_bin DEFAULT NULL,
  `deprecated_kee` varchar(400) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `projects_root_id` (`root_id`),
  KEY `projects_kee` (`kee`(255),`enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `project_links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `link_type` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `name` varchar(128) COLLATE utf8_bin DEFAULT NULL,
  `href` varchar(2048) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `project_measures` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `value` decimal(30,20) DEFAULT NULL,
  `metric_id` int(11) NOT NULL,
  `snapshot_id` int(11) DEFAULT NULL,
  `rule_id` int(11) DEFAULT NULL,
  `rules_category_id` int(11) DEFAULT NULL,
  `text_value` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `tendency` int(11) DEFAULT NULL,
  `measure_date` datetime DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `alert_status` varchar(5) COLLATE utf8_bin DEFAULT NULL,
  `alert_text` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `url` varchar(2000) COLLATE utf8_bin DEFAULT NULL,
  `description` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `rule_priority` int(11) DEFAULT NULL,
  `characteristic_id` int(11) DEFAULT NULL,
  `variation_value_1` decimal(30,20) DEFAULT NULL,
  `variation_value_2` decimal(30,20) DEFAULT NULL,
  `variation_value_3` decimal(30,20) DEFAULT NULL,
  `variation_value_4` decimal(30,20) DEFAULT NULL,
  `variation_value_5` decimal(30,20) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `measure_data` longblob,
  PRIMARY KEY (`id`),
  KEY `measures_sid_metric` (`snapshot_id`,`metric_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `properties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `prop_key` varchar(512) COLLATE utf8_bin DEFAULT NULL,
  `resource_id` int(11) DEFAULT NULL,
  `text_value` longtext COLLATE utf8_bin,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `properties_key` (`prop_key`(255))
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `quality_gates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8_bin NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_quality_gates` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `quality_gate_conditions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `qgate_id` int(11) DEFAULT NULL,
  `metric_id` int(11) DEFAULT NULL,
  `period` int(11) DEFAULT NULL,
  `operator` varchar(3) COLLATE utf8_bin DEFAULT NULL,
  `value_error` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `value_warning` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `resource_index` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kee` varchar(400) COLLATE utf8_bin NOT NULL,
  `position` int(11) NOT NULL,
  `name_size` int(11) NOT NULL,
  `resource_id` int(11) NOT NULL,
  `root_project_id` int(11) NOT NULL,
  `qualifier` varchar(10) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`),
  KEY `resource_index_key` (`kee`(255)),
  KEY `resource_index_rid` (`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `rules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plugin_rule_key` varchar(200) COLLATE utf8_bin NOT NULL,
  `plugin_config_key` varchar(200) COLLATE utf8_bin DEFAULT NULL,
  `plugin_name` varchar(255) COLLATE utf8_bin NOT NULL,
  `description` longtext COLLATE utf8_bin,
  `priority` int(11) DEFAULT NULL,
  `template_id` int(11) DEFAULT NULL,
  `name` varchar(200) COLLATE utf8_bin DEFAULT NULL,
  `status` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `language` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `note_created_at` datetime DEFAULT NULL,
  `note_updated_at` datetime DEFAULT NULL,
  `note_user_login` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `note_data` longtext COLLATE utf8_bin,
  `characteristic_id` int(11) DEFAULT NULL,
  `default_characteristic_id` int(11) DEFAULT NULL,
  `remediation_function` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `default_remediation_function` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `remediation_coeff` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `default_remediation_coeff` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `remediation_offset` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `default_remediation_offset` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `effort_to_fix_description` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `tags` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `system_tags` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `is_template` tinyint(1) NOT NULL DEFAULT '0',
  `description_format` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `rules_repo_key` (`plugin_name`,`plugin_rule_key`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `rules_parameters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rule_id` int(11) NOT NULL,
  `name` varchar(128) COLLATE utf8_bin NOT NULL,
  `description` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `param_type` varchar(512) COLLATE utf8_bin NOT NULL,
  `default_value` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rules_parameters_rule_id` (`rule_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `rules_profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8_bin NOT NULL,
  `language` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `kee` varchar(255) COLLATE utf8_bin NOT NULL,
  `parent_kee` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `rules_updated_at` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_qprof_key` (`kee`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `schema_migrations` (
  `version` varchar(255) COLLATE utf8_bin NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `semaphores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(4000) COLLATE utf8_bin NOT NULL,
  `checksum` varchar(200) COLLATE utf8_bin NOT NULL,
  `locked_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_semaphore_checksums` (`checksum`),
  KEY `semaphore_names` (`name`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `snapshots` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `project_id` int(11) NOT NULL,
  `parent_snapshot_id` int(11) DEFAULT NULL,
  `status` varchar(4) COLLATE utf8_bin NOT NULL DEFAULT 'U',
  `islast` tinyint(1) NOT NULL DEFAULT '0',
  `scope` varchar(3) COLLATE utf8_bin DEFAULT NULL,
  `qualifier` varchar(10) COLLATE utf8_bin DEFAULT NULL,
  `root_snapshot_id` int(11) DEFAULT NULL,
  `version` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `path` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `depth` int(11) DEFAULT NULL,
  `root_project_id` int(11) DEFAULT NULL,
  `period1_mode` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `period1_param` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `period1_date` datetime DEFAULT NULL,
  `period2_mode` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `period2_param` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `period2_date` datetime DEFAULT NULL,
  `period3_mode` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `period3_param` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `period3_date` datetime DEFAULT NULL,
  `period4_mode` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `period4_param` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `period4_date` datetime DEFAULT NULL,
  `period5_mode` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `period5_param` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `period5_date` datetime DEFAULT NULL,
  `build_date` datetime DEFAULT NULL,
  `purge_status` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `snapshot_project_id` (`project_id`),
  KEY `snapshots_parent` (`parent_snapshot_id`),
  KEY `snapshots_root` (`root_snapshot_id`),
  KEY `snapshots_qualifier` (`qualifier`),
  KEY `snapshots_root_project_id` (`root_project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `snapshot_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `snapshot_id` int(11) DEFAULT NULL,
  `resource_id` int(11) DEFAULT NULL,
  `snapshot_data` longtext COLLATE utf8_bin,
  `data_type` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `snapshot_data_snapshot_id` (`snapshot_id`),
  KEY `snap_data_resource_id` (`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `snapshot_sources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `snapshot_id` int(11) NOT NULL,
  `data` longtext COLLATE utf8_bin,
  PRIMARY KEY (`id`),
  KEY `snap_sources_snapshot_id` (`snapshot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `name` varchar(200) COLLATE utf8_bin DEFAULT NULL,
  `email` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `crypted_password` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `salt` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `remember_token` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `remember_token_expires_at` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_login` (`login`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `user_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `resource_id` int(11) DEFAULT NULL,
  `role` varchar(64) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_roles_user` (`user_id`),
  KEY `user_roles_resource` (`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `widgets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dashboard_id` int(11) NOT NULL,
  `widget_key` varchar(256) COLLATE utf8_bin NOT NULL,
  `name` varchar(256) COLLATE utf8_bin DEFAULT NULL,
  `description` varchar(1000) COLLATE utf8_bin DEFAULT NULL,
  `column_index` int(11) DEFAULT NULL,
  `row_index` int(11) DEFAULT NULL,
  `configured` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `resource_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `widgets_dashboards` (`dashboard_id`),
  KEY `widgets_widgetkey` (`widget_key`(255))
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `widget_properties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `widget_id` int(11) NOT NULL,
  `kee` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `text_value` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `widget_properties_widgets` (`widget_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
