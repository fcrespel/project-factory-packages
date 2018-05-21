--
-- Project Factory Setup - SonarQube schema
-- By Fabien CRESPEL <fabien@crespel.net>
--

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;


CREATE TABLE `active_rules` (
  `id` int(11) NOT NULL,
  `profile_id` int(11) NOT NULL,
  `rule_id` int(11) NOT NULL,
  `failure_level` int(11) NOT NULL,
  `inheritance` varchar(10) COLLATE utf8_bin DEFAULT NULL,
  `created_at` bigint(20) DEFAULT NULL,
  `updated_at` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `active_rule_parameters` (
  `id` int(11) NOT NULL,
  `active_rule_id` int(11) NOT NULL,
  `rules_parameter_id` int(11) NOT NULL,
  `value` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `rules_parameter_key` varchar(128) COLLATE utf8_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `analysis_properties` (
  `uuid` varchar(40) COLLATE utf8_bin NOT NULL,
  `snapshot_uuid` varchar(40) COLLATE utf8_bin NOT NULL,
  `kee` varchar(512) COLLATE utf8_bin NOT NULL,
  `text_value` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `clob_value` longtext COLLATE utf8_bin,
  `is_empty` tinyint(1) NOT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `ce_activity` (
  `id` int(11) NOT NULL,
  `uuid` varchar(40) COLLATE utf8_bin NOT NULL,
  `task_type` varchar(15) COLLATE utf8_bin NOT NULL,
  `component_uuid` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `status` varchar(15) COLLATE utf8_bin NOT NULL,
  `is_last` tinyint(1) NOT NULL,
  `is_last_key` varchar(55) COLLATE utf8_bin NOT NULL,
  `submitter_login` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `submitted_at` bigint(20) NOT NULL,
  `started_at` bigint(20) DEFAULT NULL,
  `executed_at` bigint(20) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  `updated_at` bigint(20) NOT NULL,
  `execution_time_ms` bigint(20) DEFAULT NULL,
  `analysis_uuid` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `error_message` varchar(1000) COLLATE utf8_bin DEFAULT NULL,
  `error_stacktrace` longtext COLLATE utf8_bin,
  `worker_uuid` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `execution_count` int(11) NOT NULL,
  `error_type` varchar(20) COLLATE utf8_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `ce_queue` (
  `id` int(11) NOT NULL,
  `uuid` varchar(40) COLLATE utf8_bin NOT NULL,
  `task_type` varchar(15) COLLATE utf8_bin NOT NULL,
  `component_uuid` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `status` varchar(15) COLLATE utf8_bin DEFAULT NULL,
  `submitter_login` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `started_at` bigint(20) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  `updated_at` bigint(20) NOT NULL,
  `worker_uuid` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `execution_count` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `ce_scanner_context` (
  `task_uuid` varchar(40) COLLATE utf8_bin NOT NULL,
  `context_data` longblob NOT NULL,
  `created_at` bigint(20) NOT NULL,
  `updated_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `ce_task_characteristics` (
  `uuid` varchar(40) COLLATE utf8_bin NOT NULL,
  `task_uuid` varchar(40) COLLATE utf8_bin NOT NULL,
  `kee` varchar(512) COLLATE utf8_bin NOT NULL,
  `text_value` varchar(512) COLLATE utf8_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `ce_task_input` (
  `task_uuid` varchar(40) COLLATE utf8_bin NOT NULL,
  `input_data` longblob,
  `created_at` bigint(20) NOT NULL,
  `updated_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `default_qprofiles` (
  `organization_uuid` varchar(40) COLLATE utf8_bin NOT NULL,
  `language` varchar(20) COLLATE utf8_bin NOT NULL,
  `qprofile_uuid` varchar(255) COLLATE utf8_bin NOT NULL,
  `created_at` bigint(20) NOT NULL,
  `updated_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `duplications_index` (
  `id` bigint(20) NOT NULL,
  `hash` varchar(50) COLLATE utf8_bin NOT NULL,
  `index_in_file` int(11) NOT NULL,
  `start_line` int(11) NOT NULL,
  `end_line` int(11) NOT NULL,
  `component_uuid` varchar(50) COLLATE utf8_bin NOT NULL,
  `analysis_uuid` varchar(50) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `es_queue` (
  `uuid` varchar(40) COLLATE utf8_bin NOT NULL,
  `doc_type` varchar(40) COLLATE utf8_bin NOT NULL,
  `doc_id` varchar(4000) COLLATE utf8_bin NOT NULL,
  `doc_id_type` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `doc_routing` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `events` (
  `id` int(11) NOT NULL,
  `name` varchar(400) COLLATE utf8_bin DEFAULT NULL,
  `category` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `description` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `event_data` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `event_date` bigint(20) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  `component_uuid` varchar(50) COLLATE utf8_bin NOT NULL,
  `analysis_uuid` varchar(50) COLLATE utf8_bin NOT NULL,
  `uuid` varchar(40) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `file_sources` (
  `id` int(11) NOT NULL,
  `project_uuid` varchar(50) COLLATE utf8_bin NOT NULL,
  `file_uuid` varchar(50) COLLATE utf8_bin NOT NULL,
  `line_hashes` longtext COLLATE utf8_bin,
  `data_hash` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  `updated_at` bigint(20) NOT NULL,
  `src_hash` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `binary_data` longblob,
  `data_type` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `revision` varchar(100) COLLATE utf8_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `groups` (
  `id` int(11) NOT NULL,
  `name` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `description` varchar(200) COLLATE utf8_bin DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `organization_uuid` varchar(40) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `groups_users` (
  `user_id` bigint(20) DEFAULT NULL,
  `group_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `group_roles` (
  `id` int(11) NOT NULL,
  `group_id` int(11) DEFAULT NULL,
  `resource_id` int(11) DEFAULT NULL,
  `role` varchar(64) COLLATE utf8_bin NOT NULL,
  `organization_uuid` varchar(40) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `internal_properties` (
  `kee` varchar(20) COLLATE utf8_bin NOT NULL,
  `is_empty` tinyint(1) NOT NULL,
  `text_value` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `clob_value` longtext COLLATE utf8_bin,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `issues` (
  `id` bigint(20) NOT NULL,
  `kee` varchar(50) COLLATE utf8_bin NOT NULL,
  `rule_id` int(11) DEFAULT NULL,
  `severity` varchar(10) COLLATE utf8_bin DEFAULT NULL,
  `manual_severity` tinyint(1) NOT NULL,
  `message` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `line` int(11) DEFAULT NULL,
  `gap` decimal(30,20) DEFAULT NULL,
  `status` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `resolution` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `checksum` varchar(1000) COLLATE utf8_bin DEFAULT NULL,
  `reporter` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `assignee` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `author_login` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `action_plan_key` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `issue_attributes` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `effort` int(11) DEFAULT NULL,
  `created_at` bigint(20) DEFAULT NULL,
  `updated_at` bigint(20) DEFAULT NULL,
  `issue_creation_date` bigint(20) DEFAULT NULL,
  `issue_update_date` bigint(20) DEFAULT NULL,
  `issue_close_date` bigint(20) DEFAULT NULL,
  `tags` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `component_uuid` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `project_uuid` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `locations` longblob,
  `issue_type` tinyint(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `issue_changes` (
  `id` bigint(20) NOT NULL,
  `kee` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `issue_key` varchar(50) COLLATE utf8_bin NOT NULL,
  `user_login` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `change_type` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `change_data` longtext COLLATE utf8_bin,
  `created_at` bigint(20) DEFAULT NULL,
  `updated_at` bigint(20) DEFAULT NULL,
  `issue_change_creation_date` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `loaded_templates` (
  `id` int(11) NOT NULL,
  `kee` varchar(200) COLLATE utf8_bin DEFAULT NULL,
  `template_type` varchar(64) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `manual_measures` (
  `id` bigint(20) NOT NULL,
  `metric_id` int(11) NOT NULL,
  `value` decimal(38,20) DEFAULT NULL,
  `text_value` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `user_login` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `description` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `created_at` bigint(20) DEFAULT NULL,
  `updated_at` bigint(20) DEFAULT NULL,
  `component_uuid` varchar(50) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `metrics` (
  `id` int(11) NOT NULL,
  `name` varchar(64) COLLATE utf8_bin NOT NULL,
  `description` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `direction` int(11) NOT NULL DEFAULT '0',
  `domain` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `short_name` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `qualitative` tinyint(1) NOT NULL DEFAULT '0',
  `val_type` varchar(8) COLLATE utf8_bin DEFAULT NULL,
  `user_managed` tinyint(1) DEFAULT '0',
  `enabled` tinyint(1) DEFAULT '1',
  `worst_value` decimal(38,20) DEFAULT NULL,
  `best_value` decimal(38,20) DEFAULT NULL,
  `optimized_best_value` tinyint(1) DEFAULT NULL,
  `hidden` tinyint(1) DEFAULT NULL,
  `delete_historical_data` tinyint(1) DEFAULT NULL,
  `decimal_scale` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `data` longblob
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `organizations` (
  `uuid` varchar(40) COLLATE utf8_bin NOT NULL,
  `kee` varchar(32) COLLATE utf8_bin NOT NULL,
  `name` varchar(64) COLLATE utf8_bin NOT NULL,
  `description` varchar(256) COLLATE utf8_bin DEFAULT NULL,
  `url` varchar(256) COLLATE utf8_bin DEFAULT NULL,
  `avatar_url` varchar(256) COLLATE utf8_bin DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  `updated_at` bigint(20) NOT NULL,
  `default_perm_template_project` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `default_perm_template_view` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `guarded` tinyint(1) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `default_group_id` int(11) DEFAULT NULL,
  `new_project_private` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `organization_members` (
  `organization_uuid` varchar(40) COLLATE utf8_bin NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `org_qprofiles` (
  `uuid` varchar(255) COLLATE utf8_bin NOT NULL,
  `organization_uuid` varchar(40) COLLATE utf8_bin NOT NULL,
  `rules_profile_uuid` varchar(255) COLLATE utf8_bin NOT NULL,
  `parent_uuid` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `last_used` bigint(20) DEFAULT NULL,
  `user_updated_at` bigint(20) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  `updated_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `permission_templates` (
  `id` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8_bin NOT NULL,
  `kee` varchar(100) COLLATE utf8_bin NOT NULL,
  `description` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `key_pattern` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `organization_uuid` varchar(40) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `perm_templates_groups` (
  `id` int(11) NOT NULL,
  `group_id` int(11) DEFAULT NULL,
  `template_id` int(11) NOT NULL,
  `permission_reference` varchar(64) COLLATE utf8_bin NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `perm_templates_users` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `template_id` int(11) NOT NULL,
  `permission_reference` varchar(64) COLLATE utf8_bin NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `perm_tpl_characteristics` (
  `id` int(11) NOT NULL,
  `template_id` int(11) NOT NULL,
  `permission_key` varchar(64) COLLATE utf8_bin NOT NULL,
  `with_project_creator` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` bigint(20) NOT NULL,
  `updated_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `plugins` (
  `uuid` varchar(40) COLLATE utf8_bin NOT NULL,
  `kee` varchar(200) COLLATE utf8_bin NOT NULL,
  `base_plugin_key` varchar(200) COLLATE utf8_bin DEFAULT NULL,
  `file_hash` varchar(200) COLLATE utf8_bin NOT NULL,
  `created_at` bigint(20) NOT NULL,
  `updated_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `projects` (
  `id` int(11) NOT NULL,
  `name` varchar(2000) COLLATE utf8_bin DEFAULT NULL,
  `description` varchar(2000) COLLATE utf8_bin DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `scope` varchar(3) COLLATE utf8_bin DEFAULT NULL,
  `qualifier` varchar(10) COLLATE utf8_bin DEFAULT NULL,
  `kee` varchar(400) COLLATE utf8_bin DEFAULT NULL,
  `language` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `long_name` varchar(2000) COLLATE utf8_bin DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `path` varchar(2000) COLLATE utf8_bin DEFAULT NULL,
  `deprecated_kee` varchar(400) COLLATE utf8_bin DEFAULT NULL,
  `uuid` varchar(50) COLLATE utf8_bin NOT NULL,
  `project_uuid` varchar(50) COLLATE utf8_bin NOT NULL,
  `module_uuid` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `module_uuid_path` varchar(1500) COLLATE utf8_bin DEFAULT NULL,
  `authorization_updated_at` bigint(20) DEFAULT NULL,
  `root_uuid` varchar(50) COLLATE utf8_bin NOT NULL,
  `copy_component_uuid` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `developer_uuid` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `uuid_path` varchar(1500) COLLATE utf8_bin NOT NULL,
  `b_changed` tinyint(1) DEFAULT NULL,
  `b_copy_component_uuid` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `b_description` varchar(2000) COLLATE utf8_bin DEFAULT NULL,
  `b_enabled` tinyint(1) DEFAULT NULL,
  `b_language` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `b_long_name` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `b_module_uuid` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `b_module_uuid_path` varchar(1500) COLLATE utf8_bin DEFAULT NULL,
  `b_name` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `b_path` varchar(2000) COLLATE utf8_bin DEFAULT NULL,
  `b_qualifier` varchar(10) COLLATE utf8_bin DEFAULT NULL,
  `b_uuid_path` varchar(1500) COLLATE utf8_bin DEFAULT NULL,
  `organization_uuid` varchar(40) COLLATE utf8_bin NOT NULL,
  `tags` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `private` tinyint(1) NOT NULL,
  `main_branch_project_uuid` varchar(50) COLLATE utf8_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `project_branches` (
  `uuid` varchar(50) COLLATE utf8_bin NOT NULL,
  `project_uuid` varchar(50) COLLATE utf8_bin NOT NULL,
  `kee` varchar(255) COLLATE utf8_bin NOT NULL,
  `branch_type` varchar(5) COLLATE utf8_bin DEFAULT NULL,
  `merge_branch_uuid` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  `updated_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `project_links` (
  `id` int(11) NOT NULL,
  `link_type` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `name` varchar(128) COLLATE utf8_bin DEFAULT NULL,
  `href` varchar(2048) COLLATE utf8_bin NOT NULL,
  `component_uuid` varchar(2048) COLLATE utf8_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `project_measures` (
  `id` bigint(20) NOT NULL,
  `value` decimal(38,20) DEFAULT NULL,
  `metric_id` int(11) NOT NULL,
  `text_value` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `alert_status` varchar(5) COLLATE utf8_bin DEFAULT NULL,
  `alert_text` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `description` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `variation_value_1` decimal(38,20) DEFAULT NULL,
  `variation_value_2` decimal(38,20) DEFAULT NULL,
  `variation_value_3` decimal(38,20) DEFAULT NULL,
  `variation_value_4` decimal(38,20) DEFAULT NULL,
  `variation_value_5` decimal(38,20) DEFAULT NULL,
  `measure_data` longblob,
  `component_uuid` varchar(50) COLLATE utf8_bin NOT NULL,
  `analysis_uuid` varchar(50) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `project_qprofiles` (
  `id` int(11) NOT NULL,
  `project_uuid` varchar(50) COLLATE utf8_bin NOT NULL,
  `profile_key` varchar(50) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `properties` (
  `id` int(11) NOT NULL,
  `prop_key` varchar(512) COLLATE utf8_bin NOT NULL,
  `resource_id` bigint(20) DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `is_empty` tinyint(1) NOT NULL,
  `text_value` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `clob_value` longtext COLLATE utf8_bin,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `qprofile_changes` (
  `kee` varchar(40) COLLATE utf8_bin NOT NULL,
  `rules_profile_uuid` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `change_type` varchar(20) COLLATE utf8_bin NOT NULL,
  `user_login` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `change_data` longtext COLLATE utf8_bin,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `qprofile_edit_groups` (
  `uuid` varchar(40) COLLATE utf8_bin NOT NULL,
  `group_id` int(11) NOT NULL,
  `qprofile_uuid` varchar(255) COLLATE utf8_bin NOT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `qprofile_edit_users` (
  `uuid` varchar(40) COLLATE utf8_bin NOT NULL,
  `user_id` int(11) NOT NULL,
  `qprofile_uuid` varchar(255) COLLATE utf8_bin NOT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `quality_gates` (
  `id` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8_bin NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `quality_gate_conditions` (
  `id` int(11) NOT NULL,
  `qgate_id` int(11) DEFAULT NULL,
  `metric_id` int(11) DEFAULT NULL,
  `period` int(11) DEFAULT NULL,
  `operator` varchar(3) COLLATE utf8_bin DEFAULT NULL,
  `value_error` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `value_warning` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `rules` (
  `id` int(11) NOT NULL,
  `name` varchar(200) COLLATE utf8_bin DEFAULT NULL,
  `plugin_rule_key` varchar(200) COLLATE utf8_bin NOT NULL,
  `plugin_config_key` varchar(200) COLLATE utf8_bin DEFAULT NULL,
  `plugin_name` varchar(255) COLLATE utf8_bin NOT NULL,
  `description` longtext COLLATE utf8_bin,
  `priority` int(11) DEFAULT NULL,
  `template_id` int(11) DEFAULT NULL,
  `status` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `language` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `def_remediation_function` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `def_remediation_gap_mult` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `def_remediation_base_effort` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `gap_description` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `system_tags` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `is_template` tinyint(1) NOT NULL DEFAULT '0',
  `description_format` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `created_at` bigint(20) DEFAULT NULL,
  `updated_at` bigint(20) DEFAULT NULL,
  `rule_type` tinyint(2) DEFAULT NULL,
  `plugin_key` varchar(200) COLLATE utf8_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `rules_metadata` (
  `rule_id` int(11) NOT NULL,
  `organization_uuid` varchar(40) COLLATE utf8_bin NOT NULL,
  `note_data` longtext COLLATE utf8_bin,
  `note_user_login` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `note_created_at` bigint(20) DEFAULT NULL,
  `note_updated_at` bigint(20) DEFAULT NULL,
  `remediation_function` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `remediation_gap_mult` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `remediation_base_effort` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `tags` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  `updated_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `rules_parameters` (
  `id` int(11) NOT NULL,
  `rule_id` int(11) NOT NULL,
  `name` varchar(128) COLLATE utf8_bin NOT NULL,
  `description` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `param_type` varchar(512) COLLATE utf8_bin NOT NULL,
  `default_value` varchar(4000) COLLATE utf8_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `rules_profiles` (
  `id` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8_bin NOT NULL,
  `language` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `kee` varchar(255) COLLATE utf8_bin NOT NULL,
  `rules_updated_at` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_built_in` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `rule_repositories` (
  `kee` varchar(200) COLLATE utf8_bin NOT NULL,
  `language` varchar(20) COLLATE utf8_bin NOT NULL,
  `name` varchar(4000) COLLATE utf8_bin NOT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `snapshots` (
  `id` int(11) NOT NULL,
  `status` varchar(4) COLLATE utf8_bin NOT NULL DEFAULT 'U',
  `islast` tinyint(1) NOT NULL DEFAULT '0',
  `version` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `purge_status` int(11) DEFAULT NULL,
  `period1_mode` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `period1_param` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `period2_mode` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `period2_param` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `period3_mode` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `period3_param` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `period4_mode` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `period4_param` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `period5_mode` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `period5_param` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `created_at` bigint(20) DEFAULT NULL,
  `build_date` bigint(20) DEFAULT NULL,
  `period1_date` bigint(20) DEFAULT NULL,
  `period2_date` bigint(20) DEFAULT NULL,
  `period3_date` bigint(20) DEFAULT NULL,
  `period4_date` bigint(20) DEFAULT NULL,
  `period5_date` bigint(20) DEFAULT NULL,
  `component_uuid` varchar(50) COLLATE utf8_bin NOT NULL,
  `uuid` varchar(50) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `login` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `name` varchar(200) COLLATE utf8_bin DEFAULT NULL,
  `email` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `crypted_password` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `salt` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  `created_at` bigint(20) DEFAULT NULL,
  `updated_at` bigint(20) DEFAULT NULL,
  `scm_accounts` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `external_identity` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `external_identity_provider` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `user_local` tinyint(1) DEFAULT NULL,
  `is_root` tinyint(1) NOT NULL,
  `onboarded` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `user_roles` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `resource_id` int(11) DEFAULT NULL,
  `role` varchar(64) COLLATE utf8_bin NOT NULL,
  `organization_uuid` varchar(40) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `user_tokens` (
  `id` int(11) NOT NULL,
  `login` varchar(255) COLLATE utf8_bin NOT NULL,
  `name` varchar(100) COLLATE utf8_bin NOT NULL,
  `token_hash` varchar(255) COLLATE utf8_bin NOT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `webhook_deliveries` (
  `uuid` varchar(40) COLLATE utf8_bin NOT NULL,
  `component_uuid` varchar(40) COLLATE utf8_bin NOT NULL,
  `ce_task_uuid` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `name` varchar(100) COLLATE utf8_bin NOT NULL,
  `url` varchar(2000) COLLATE utf8_bin NOT NULL,
  `success` tinyint(1) NOT NULL,
  `http_status` int(11) DEFAULT NULL,
  `duration_ms` int(11) DEFAULT NULL,
  `payload` longtext COLLATE utf8_bin NOT NULL,
  `error_stacktrace` longtext COLLATE utf8_bin,
  `created_at` bigint(20) NOT NULL,
  `analysis_uuid` varchar(40) COLLATE utf8_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


ALTER TABLE `active_rules`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_profile_rule_ids` (`profile_id`,`rule_id`);

ALTER TABLE `active_rule_parameters`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ix_arp_on_active_rule_id` (`active_rule_id`);

ALTER TABLE `analysis_properties`
  ADD PRIMARY KEY (`uuid`),
  ADD KEY `ix_snapshot_uuid` (`snapshot_uuid`);

ALTER TABLE `ce_activity`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ce_activity_uuid` (`uuid`),
  ADD KEY `ce_activity_component_uuid` (`component_uuid`),
  ADD KEY `ce_activity_islast_status` (`is_last`,`status`),
  ADD KEY `ce_activity_islastkey` (`is_last_key`);

ALTER TABLE `ce_queue`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ce_queue_uuid` (`uuid`),
  ADD KEY `ce_queue_component_uuid` (`component_uuid`);

ALTER TABLE `ce_scanner_context`
  ADD PRIMARY KEY (`task_uuid`);

ALTER TABLE `ce_task_characteristics`
  ADD PRIMARY KEY (`uuid`),
  ADD KEY `ce_characteristics_task_uuid` (`task_uuid`);

ALTER TABLE `ce_task_input`
  ADD PRIMARY KEY (`task_uuid`);

ALTER TABLE `default_qprofiles`
  ADD PRIMARY KEY (`organization_uuid`,`language`),
  ADD UNIQUE KEY `uniq_default_qprofiles_uuid` (`qprofile_uuid`);

ALTER TABLE `duplications_index`
  ADD PRIMARY KEY (`id`),
  ADD KEY `duplications_index_hash` (`hash`),
  ADD KEY `duplication_analysis_component` (`analysis_uuid`,`component_uuid`);

ALTER TABLE `es_queue`
  ADD PRIMARY KEY (`uuid`),
  ADD KEY `es_queue_created_at` (`created_at`);

ALTER TABLE `events`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `events_uuid` (`uuid`),
  ADD KEY `events_analysis` (`analysis_uuid`),
  ADD KEY `events_component_uuid` (`component_uuid`);

ALTER TABLE `file_sources`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `file_sources_uuid_type` (`file_uuid`,`data_type`),
  ADD KEY `file_sources_project_uuid` (`project_uuid`),
  ADD KEY `file_sources_updated_at` (`updated_at`);

ALTER TABLE `groups`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `groups_users`
  ADD UNIQUE KEY `groups_users_unique` (`group_id`,`user_id`),
  ADD KEY `index_groups_users_on_user_id` (`user_id`),
  ADD KEY `index_groups_users_on_group_id` (`group_id`);

ALTER TABLE `group_roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_group_roles` (`organization_uuid`,`group_id`,`resource_id`,`role`),
  ADD KEY `group_roles_resource` (`resource_id`);

ALTER TABLE `internal_properties`
  ADD PRIMARY KEY (`kee`);

ALTER TABLE `issues`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `issues_kee` (`kee`),
  ADD KEY `issues_assignee` (`assignee`),
  ADD KEY `issues_component_uuid` (`component_uuid`),
  ADD KEY `issues_creation_date` (`issue_creation_date`),
  ADD KEY `issues_project_uuid` (`project_uuid`),
  ADD KEY `issues_resolution` (`resolution`),
  ADD KEY `issues_rule_id` (`rule_id`),
  ADD KEY `issues_updated_at` (`updated_at`);

ALTER TABLE `issue_changes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `issue_changes_issue_key` (`issue_key`),
  ADD KEY `issue_changes_kee` (`kee`);

ALTER TABLE `loaded_templates`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ix_loaded_templates_type` (`template_type`);

ALTER TABLE `manual_measures`
  ADD PRIMARY KEY (`id`),
  ADD KEY `manual_measures_component_uuid` (`component_uuid`);

ALTER TABLE `metrics`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `metrics_unique_name` (`name`);

ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `organizations`
  ADD PRIMARY KEY (`uuid`),
  ADD UNIQUE KEY `organization_key` (`kee`);

ALTER TABLE `organization_members`
  ADD PRIMARY KEY (`organization_uuid`,`user_id`);

ALTER TABLE `org_qprofiles`
  ADD PRIMARY KEY (`uuid`),
  ADD KEY `qprofiles_org_uuid` (`organization_uuid`),
  ADD KEY `qprofiles_rp_uuid` (`rules_profile_uuid`);

ALTER TABLE `permission_templates`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `perm_templates_groups`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `perm_templates_users`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `perm_tpl_characteristics`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_perm_tpl_charac` (`template_id`,`permission_key`);

ALTER TABLE `plugins`
  ADD PRIMARY KEY (`uuid`),
  ADD UNIQUE KEY `plugins_key` (`kee`);

ALTER TABLE `projects`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `projects_kee` (`kee`(255)),
  ADD KEY `projects_module_uuid` (`module_uuid`),
  ADD KEY `projects_qualifier` (`qualifier`),
  ADD KEY `projects_root_uuid` (`root_uuid`),
  ADD KEY `projects_uuid` (`uuid`),
  ADD KEY `projects_organization` (`organization_uuid`),
  ADD KEY `projects_project_uuid` (`project_uuid`);

ALTER TABLE `project_branches`
  ADD PRIMARY KEY (`uuid`),
  ADD UNIQUE KEY `project_branches_kee` (`project_uuid`,`kee`);

ALTER TABLE `project_links`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `project_measures`
  ADD PRIMARY KEY (`id`),
  ADD KEY `measures_person` (`person_id`),
  ADD KEY `measures_component_uuid` (`component_uuid`),
  ADD KEY `measures_analysis_metric` (`analysis_uuid`,`metric_id`);

ALTER TABLE `project_qprofiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_project_qprofiles` (`project_uuid`,`profile_key`);

ALTER TABLE `properties`
  ADD PRIMARY KEY (`id`),
  ADD KEY `properties_key` (`prop_key`(255));

ALTER TABLE `qprofile_changes`
  ADD PRIMARY KEY (`kee`),
  ADD KEY `qp_changes_rules_profile_uuid` (`rules_profile_uuid`);

ALTER TABLE `qprofile_edit_groups`
  ADD PRIMARY KEY (`uuid`),
  ADD UNIQUE KEY `qprofile_edit_groups_unique` (`group_id`,`qprofile_uuid`),
  ADD KEY `qprofile_edit_groups_qprofile` (`qprofile_uuid`);

ALTER TABLE `qprofile_edit_users`
  ADD PRIMARY KEY (`uuid`),
  ADD UNIQUE KEY `qprofile_edit_users_unique` (`user_id`,`qprofile_uuid`),
  ADD KEY `qprofile_edit_users_qprofile` (`qprofile_uuid`);

ALTER TABLE `quality_gates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_quality_gates` (`name`);

ALTER TABLE `quality_gate_conditions`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `rules`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `rules_repo_key` (`plugin_rule_key`,`plugin_name`);

ALTER TABLE `rules_metadata`
  ADD PRIMARY KEY (`rule_id`,`organization_uuid`);

ALTER TABLE `rules_parameters`
  ADD PRIMARY KEY (`id`),
  ADD KEY `rules_parameters_rule_id` (`rule_id`);

ALTER TABLE `rules_profiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_qprof_key` (`kee`);

ALTER TABLE `rule_repositories`
  ADD PRIMARY KEY (`kee`);

ALTER TABLE `snapshots`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `analyses_uuid` (`uuid`),
  ADD KEY `snapshot_component` (`component_uuid`);

ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_login` (`login`),
  ADD KEY `users_updated_at` (`updated_at`);

ALTER TABLE `user_roles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_roles_resource` (`resource_id`),
  ADD KEY `user_roles_user` (`user_id`);

ALTER TABLE `user_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_tokens_login_name` (`login`,`name`),
  ADD UNIQUE KEY `user_tokens_token_hash` (`token_hash`);

ALTER TABLE `webhook_deliveries`
  ADD PRIMARY KEY (`uuid`),
  ADD KEY `component_uuid` (`component_uuid`),
  ADD KEY `ce_task_uuid` (`ce_task_uuid`);


ALTER TABLE `active_rules`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `active_rule_parameters`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `ce_activity`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `ce_queue`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `duplications_index`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

ALTER TABLE `events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `file_sources`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `groups`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `group_roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `issues`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

ALTER TABLE `issue_changes`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

ALTER TABLE `loaded_templates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `manual_measures`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

ALTER TABLE `metrics`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `permission_templates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `perm_templates_groups`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `perm_templates_users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `perm_tpl_characteristics`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `projects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `project_links`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `project_measures`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

ALTER TABLE `project_qprofiles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `properties`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `quality_gates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `quality_gate_conditions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `rules`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `rules_parameters`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `rules_profiles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `snapshots`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `user_roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `user_tokens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
