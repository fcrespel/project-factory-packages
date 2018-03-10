--
-- Project Factory Setup - GitLab schema
-- By Fabien CRESPEL <fabien@crespel.net>
--

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;


CREATE TABLE IF NOT EXISTS `abuse_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reporter_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `message` longtext,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `message_html` longtext,
  `cached_markdown_version` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `appearances` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` longtext NOT NULL,
  `header_logo` varchar(255) DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `description_html` longtext,
  `cached_markdown_version` int(11) DEFAULT NULL,
  `new_project_guidelines` text,
  `new_project_guidelines_html` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `application_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `default_projects_limit` int(11) DEFAULT NULL,
  `signup_enabled` tinyint(1) DEFAULT NULL,
  `gravatar_enabled` tinyint(1) DEFAULT NULL,
  `sign_in_text` longtext,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `home_page_url` varchar(255) DEFAULT NULL,
  `default_branch_protection` int(11) DEFAULT '2',
  `restricted_visibility_levels` longtext,
  `version_check_enabled` tinyint(1) DEFAULT '1',
  `max_attachment_size` int(11) NOT NULL DEFAULT '10',
  `default_project_visibility` int(11) DEFAULT NULL,
  `default_snippet_visibility` int(11) DEFAULT NULL,
  `domain_whitelist` longtext,
  `user_oauth_applications` tinyint(1) DEFAULT '1',
  `after_sign_out_path` varchar(255) DEFAULT NULL,
  `session_expire_delay` int(11) NOT NULL DEFAULT '10080',
  `import_sources` longtext,
  `help_page_text` longtext,
  `admin_notification_email` varchar(255) DEFAULT NULL,
  `shared_runners_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `max_artifacts_size` int(11) NOT NULL DEFAULT '100',
  `runners_registration_token` varchar(255) DEFAULT NULL,
  `max_pages_size` int(11) NOT NULL DEFAULT '100',
  `require_two_factor_authentication` tinyint(1) DEFAULT '0',
  `two_factor_grace_period` int(11) DEFAULT '48',
  `metrics_enabled` tinyint(1) DEFAULT '0',
  `metrics_host` varchar(255) DEFAULT 'localhost',
  `metrics_pool_size` int(11) DEFAULT '16',
  `metrics_timeout` int(11) DEFAULT '10',
  `metrics_method_call_threshold` int(11) DEFAULT '10',
  `recaptcha_enabled` tinyint(1) DEFAULT '0',
  `recaptcha_site_key` varchar(255) DEFAULT NULL,
  `recaptcha_private_key` varchar(255) DEFAULT NULL,
  `metrics_port` int(11) DEFAULT '8089',
  `akismet_enabled` tinyint(1) DEFAULT '0',
  `akismet_api_key` varchar(255) DEFAULT NULL,
  `metrics_sample_interval` int(11) DEFAULT '15',
  `sentry_enabled` tinyint(1) DEFAULT '0',
  `sentry_dsn` varchar(255) DEFAULT NULL,
  `email_author_in_body` tinyint(1) DEFAULT '0',
  `default_group_visibility` int(11) DEFAULT NULL,
  `repository_checks_enabled` tinyint(1) DEFAULT '0',
  `shared_runners_text` longtext,
  `metrics_packet_size` int(11) DEFAULT '1',
  `disabled_oauth_sign_in_sources` longtext,
  `health_check_access_token` varchar(255) DEFAULT NULL,
  `send_user_confirmation_email` tinyint(1) DEFAULT '0',
  `container_registry_token_expire_delay` int(11) DEFAULT '5',
  `after_sign_up_text` longtext,
  `user_default_external` tinyint(1) NOT NULL DEFAULT '0',
  `repository_storages` varchar(255) DEFAULT 'default',
  `enabled_git_access_protocol` varchar(255) DEFAULT NULL,
  `domain_blacklist_enabled` tinyint(1) DEFAULT '0',
  `domain_blacklist` longtext,
  `usage_ping_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `koding_enabled` tinyint(1) DEFAULT NULL,
  `koding_url` varchar(255) DEFAULT NULL,
  `sign_in_text_html` longtext,
  `help_page_text_html` longtext,
  `shared_runners_text_html` longtext,
  `after_sign_up_text_html` longtext,
  `rsa_key_restriction` int(11) NOT NULL DEFAULT '0',
  `dsa_key_restriction` int(11) NOT NULL DEFAULT '0',
  `ecdsa_key_restriction` int(11) NOT NULL DEFAULT '0',
  `ed25519_key_restriction` int(11) NOT NULL DEFAULT '0',
  `housekeeping_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `housekeeping_bitmaps_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `housekeeping_incremental_repack_period` int(11) NOT NULL DEFAULT '10',
  `housekeeping_full_repack_period` int(11) NOT NULL DEFAULT '50',
  `housekeeping_gc_period` int(11) NOT NULL DEFAULT '200',
  `sidekiq_throttling_enabled` tinyint(1) DEFAULT '0',
  `sidekiq_throttling_queues` varchar(255) DEFAULT NULL,
  `sidekiq_throttling_factor` decimal(10,0) DEFAULT NULL,
  `html_emails_enabled` tinyint(1) DEFAULT '1',
  `plantuml_url` varchar(255) DEFAULT NULL,
  `plantuml_enabled` tinyint(1) DEFAULT NULL,
  `terminal_max_session_time` int(11) NOT NULL DEFAULT '0',
  `unique_ips_limit_per_user` int(11) DEFAULT NULL,
  `unique_ips_limit_time_window` int(11) DEFAULT NULL,
  `unique_ips_limit_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `default_artifacts_expire_in` varchar(255) NOT NULL DEFAULT '0',
  `uuid` varchar(255) DEFAULT NULL,
  `polling_interval_multiplier` decimal(10,0) NOT NULL DEFAULT '1',
  `cached_markdown_version` int(11) DEFAULT NULL,
  `clientside_sentry_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `clientside_sentry_dsn` varchar(255) DEFAULT NULL,
  `prometheus_metrics_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `help_page_hide_commercial_content` tinyint(1) DEFAULT '0',
  `help_page_support_url` varchar(255) DEFAULT NULL,
  `performance_bar_allowed_group_id` int(11) DEFAULT NULL,
  `hashed_storage_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `project_export_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `auto_devops_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `circuitbreaker_failure_count_threshold` int(11) DEFAULT '3',
  `circuitbreaker_failure_reset_time` int(11) DEFAULT '1800',
  `circuitbreaker_storage_timeout` int(11) DEFAULT '15',
  `circuitbreaker_access_retries` int(11) DEFAULT '3',
  `authorized_keys_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `throttle_unauthenticated_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `throttle_unauthenticated_requests_per_period` int(11) NOT NULL DEFAULT '3600',
  `throttle_unauthenticated_period_in_seconds` int(11) NOT NULL DEFAULT '3600',
  `throttle_authenticated_api_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `throttle_authenticated_api_requests_per_period` int(11) NOT NULL DEFAULT '7200',
  `throttle_authenticated_api_period_in_seconds` int(11) NOT NULL DEFAULT '3600',
  `throttle_authenticated_web_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `throttle_authenticated_web_requests_per_period` int(11) NOT NULL DEFAULT '7200',
  `throttle_authenticated_web_period_in_seconds` int(11) NOT NULL DEFAULT '3600',
  `gitaly_timeout_default` int(11) NOT NULL DEFAULT '55',
  `gitaly_timeout_medium` int(11) NOT NULL DEFAULT '30',
  `gitaly_timeout_fast` int(11) NOT NULL DEFAULT '10',
  `password_authentication_enabled_for_web` tinyint(1) DEFAULT NULL,
  `password_authentication_enabled_for_git` tinyint(1) NOT NULL DEFAULT '1',
  `circuitbreaker_check_interval` int(11) NOT NULL DEFAULT '1',
  `auto_devops_domain` varchar(255) DEFAULT NULL,
  `pages_domain_verification_enabled` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `audit_events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author_id` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `entity_id` int(11) NOT NULL,
  `entity_type` varchar(255) NOT NULL,
  `details` longtext,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_audit_events_on_entity_id_and_entity_type` (`entity_id`,`entity_type`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `award_emoji` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `awardable_id` int(11) DEFAULT NULL,
  `awardable_type` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_award_emoji_on_awardable_type_and_awardable_id` (`awardable_type`,`awardable_id`) USING BTREE,
  KEY `index_award_emoji_on_user_id_and_name` (`user_id`,`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `boards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_boards_on_project_id` (`project_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `broadcast_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` longtext NOT NULL,
  `starts_at` datetime NOT NULL,
  `ends_at` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `color` varchar(255) DEFAULT NULL,
  `font` varchar(255) DEFAULT NULL,
  `message_html` longtext NOT NULL,
  `cached_markdown_version` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_broadcast_messages_on_starts_at_and_ends_at_and_id` (`starts_at`,`ends_at`,`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `chat_names` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `service_id` int(11) NOT NULL,
  `team_id` varchar(255) NOT NULL,
  `team_domain` varchar(255) DEFAULT NULL,
  `chat_id` varchar(255) NOT NULL,
  `chat_name` varchar(255) DEFAULT NULL,
  `last_used_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_chat_names_on_service_id_and_team_id_and_chat_id` (`service_id`,`team_id`,`chat_id`) USING BTREE,
  UNIQUE KEY `index_chat_names_on_user_id_and_service_id` (`user_id`,`service_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `chat_teams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `namespace_id` int(11) NOT NULL,
  `team_id` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_chat_teams_on_namespace_id` (`namespace_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `ci_builds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(255) DEFAULT NULL,
  `finished_at` datetime DEFAULT NULL,
  `trace` longtext,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `started_at` datetime DEFAULT NULL,
  `runner_id` int(11) DEFAULT NULL,
  `coverage` float DEFAULT NULL,
  `commit_id` int(11) DEFAULT NULL,
  `commands` longtext,
  `name` varchar(255) DEFAULT NULL,
  `options` longtext,
  `allow_failure` tinyint(1) NOT NULL DEFAULT '0',
  `stage` varchar(255) DEFAULT NULL,
  `trigger_request_id` int(11) DEFAULT NULL,
  `stage_idx` int(11) DEFAULT NULL,
  `tag` tinyint(1) DEFAULT NULL,
  `ref` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `target_url` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `artifacts_file` longtext,
  `project_id` int(11) DEFAULT NULL,
  `artifacts_metadata` longtext,
  `erased_by_id` int(11) DEFAULT NULL,
  `erased_at` datetime DEFAULT NULL,
  `artifacts_expire_at` datetime DEFAULT NULL,
  `environment` varchar(255) DEFAULT NULL,
  `artifacts_size` bigint(20) DEFAULT NULL,
  `when` varchar(255) DEFAULT NULL,
  `yaml_variables` longtext,
  `queued_at` datetime DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `lock_version` int(11) DEFAULT NULL,
  `coverage_regex` varchar(255) DEFAULT NULL,
  `auto_canceled_by_id` int(11) DEFAULT NULL,
  `retried` tinyint(1) DEFAULT NULL,
  `stage_id` int(11) DEFAULT NULL,
  `protected` tinyint(1) DEFAULT NULL,
  `failure_reason` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_ci_builds_on_token` (`token`) USING BTREE,
  KEY `index_ci_builds_on_auto_canceled_by_id` (`auto_canceled_by_id`) USING BTREE,
  KEY `index_ci_builds_on_commit_id_and_stage_idx_and_created_at` (`commit_id`,`stage_idx`,`created_at`) USING BTREE,
  KEY `index_ci_builds_on_commit_id_and_status_and_type` (`commit_id`,`status`,`type`) USING BTREE,
  KEY `index_ci_builds_on_commit_id_and_type_and_name_and_ref` (`commit_id`,`type`,`name`,`ref`) USING BTREE,
  KEY `index_ci_builds_on_commit_id_and_type_and_ref` (`commit_id`,`type`,`ref`) USING BTREE,
  KEY `index_ci_builds_on_project_id_and_id` (`project_id`,`id`) USING BTREE,
  KEY `index_ci_builds_on_protected` (`protected`) USING BTREE,
  KEY `index_ci_builds_on_runner_id` (`runner_id`) USING BTREE,
  KEY `index_ci_builds_on_stage_id` (`stage_id`) USING BTREE,
  KEY `index_ci_builds_on_status_and_type_and_runner_id` (`status`,`type`,`runner_id`) USING BTREE,
  KEY `index_ci_builds_on_status` (`status`) USING BTREE,
  KEY `index_ci_builds_on_updated_at` (`updated_at`) USING BTREE,
  KEY `index_ci_builds_on_user_id` (`user_id`) USING BTREE,
  KEY `index_ci_builds_on_artifacts_expire_at` (`artifacts_expire_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `ci_build_trace_sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `date_start` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_end` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `byte_start` bigint(20) NOT NULL,
  `byte_end` bigint(20) NOT NULL,
  `build_id` int(11) NOT NULL,
  `section_name_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_ci_build_trace_sections_on_build_id_and_section_name_id` (`build_id`,`section_name_id`) USING BTREE,
  KEY `index_ci_build_trace_sections_on_project_id` (`project_id`) USING BTREE,
  KEY `fk_264e112c66` (`section_name_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `ci_build_trace_section_names` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_ci_build_trace_section_names_on_project_id_and_name` (`project_id`,`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `ci_group_variables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `value` longtext,
  `encrypted_value` longtext,
  `encrypted_value_salt` varchar(255) DEFAULT NULL,
  `encrypted_value_iv` varchar(255) DEFAULT NULL,
  `group_id` int(11) NOT NULL,
  `protected` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_ci_group_variables_on_group_id_and_key` (`group_id`,`key`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `ci_job_artifacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `job_id` int(11) NOT NULL,
  `file_type` int(11) NOT NULL,
  `size` bigint(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `expire_at` timestamp NULL DEFAULT NULL,
  `file` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_ci_job_artifacts_on_job_id_and_file_type` (`job_id`,`file_type`),
  KEY `index_ci_job_artifacts_on_project_id` (`project_id`),
  KEY `index_ci_job_artifacts_on_expire_at_and_job_id` (`expire_at`,`job_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `ci_pipelines` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ref` varchar(255) DEFAULT NULL,
  `sha` varchar(255) DEFAULT NULL,
  `before_sha` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `tag` tinyint(1) DEFAULT '0',
  `yaml_errors` longtext,
  `committed_at` datetime DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `started_at` datetime DEFAULT NULL,
  `finished_at` datetime DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `lock_version` int(11) DEFAULT NULL,
  `auto_canceled_by_id` int(11) DEFAULT NULL,
  `pipeline_schedule_id` int(11) DEFAULT NULL,
  `source` int(11) DEFAULT NULL,
  `config_source` int(11) DEFAULT NULL,
  `protected` tinyint(1) DEFAULT NULL,
  `failure_reason` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_ci_pipelines_on_auto_canceled_by_id` (`auto_canceled_by_id`) USING BTREE,
  KEY `index_ci_pipelines_on_pipeline_schedule_id` (`pipeline_schedule_id`) USING BTREE,
  KEY `index_ci_pipelines_on_project_id_and_ref_and_status_and_id` (`project_id`,`ref`,`status`,`id`) USING BTREE,
  KEY `index_ci_pipelines_on_project_id_and_sha` (`project_id`,`sha`) USING BTREE,
  KEY `index_ci_pipelines_on_project_id` (`project_id`) USING BTREE,
  KEY `index_ci_pipelines_on_status` (`status`) USING BTREE,
  KEY `index_ci_pipelines_on_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `ci_pipeline_schedules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `ref` varchar(255) DEFAULT NULL,
  `cron` varchar(255) DEFAULT NULL,
  `cron_timezone` varchar(255) DEFAULT NULL,
  `next_run_at` datetime DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_ci_pipeline_schedules_on_next_run_at_and_active` (`next_run_at`,`active`) USING BTREE,
  KEY `index_ci_pipeline_schedules_on_project_id` (`project_id`) USING BTREE,
  KEY `fk_9ea99f58d2` (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `ci_pipeline_schedule_variables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `value` longtext,
  `encrypted_value` longtext,
  `encrypted_value_salt` varchar(255) DEFAULT NULL,
  `encrypted_value_iv` varchar(255) DEFAULT NULL,
  `pipeline_schedule_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_ci_pipeline_schedule_variables_on_schedule_id_and_key` (`pipeline_schedule_id`,`key`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `ci_pipeline_variables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `value` longtext,
  `encrypted_value` longtext,
  `encrypted_value_salt` varchar(255) DEFAULT NULL,
  `encrypted_value_iv` varchar(255) DEFAULT NULL,
  `pipeline_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_ci_pipeline_variables_on_pipeline_id_and_key` (`pipeline_id`,`key`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `ci_runners` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `contacted_at` datetime DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `is_shared` tinyint(1) DEFAULT '0',
  `name` varchar(255) DEFAULT NULL,
  `version` varchar(255) DEFAULT NULL,
  `revision` varchar(255) DEFAULT NULL,
  `platform` varchar(255) DEFAULT NULL,
  `architecture` varchar(255) DEFAULT NULL,
  `run_untagged` tinyint(1) NOT NULL DEFAULT '1',
  `locked` tinyint(1) NOT NULL DEFAULT '0',
  `access_level` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_ci_runners_on_contacted_at` (`contacted_at`) USING BTREE,
  KEY `index_ci_runners_on_is_shared` (`is_shared`) USING BTREE,
  KEY `index_ci_runners_on_locked` (`locked`) USING BTREE,
  KEY `index_ci_runners_on_token` (`token`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `ci_runner_projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `runner_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_ci_runner_projects_on_project_id` (`project_id`) USING BTREE,
  KEY `index_ci_runner_projects_on_runner_id` (`runner_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `ci_stages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `pipeline_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `lock_version` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_ci_stages_on_pipeline_id_and_name` (`pipeline_id`,`name`),
  KEY `index_ci_stages_on_pipeline_id` (`pipeline_id`) USING BTREE,
  KEY `index_ci_stages_on_project_id` (`project_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `ci_triggers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `ref` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_ci_triggers_on_project_id` (`project_id`) USING BTREE,
  KEY `fk_e8e10d1964` (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `ci_trigger_requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `trigger_id` int(11) NOT NULL,
  `variables` longtext,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `commit_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_ci_trigger_requests_on_commit_id` (`commit_id`) USING BTREE,
  KEY `fk_b8ec8b7245` (`trigger_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `ci_variables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `value` longtext,
  `encrypted_value` longtext,
  `encrypted_value_salt` varchar(255) DEFAULT NULL,
  `encrypted_value_iv` varchar(255) DEFAULT NULL,
  `project_id` int(11) NOT NULL,
  `protected` tinyint(1) NOT NULL DEFAULT '0',
  `environment_scope` varchar(255) NOT NULL DEFAULT '*',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_ci_variables_on_project_id_and_key_and_environment_scope` (`project_id`,`key`,`environment_scope`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `clusters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `provider_type` int(11) DEFAULT NULL,
  `platform_type` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `enabled` tinyint(1) DEFAULT '1',
  `name` varchar(255) NOT NULL,
  `environment_scope` varchar(255) NOT NULL DEFAULT '*',
  PRIMARY KEY (`id`),
  KEY `index_clusters_on_enabled` (`enabled`) USING BTREE,
  KEY `index_clusters_on_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `clusters_applications_helm` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cluster_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `status` int(11) NOT NULL,
  `version` varchar(255) NOT NULL,
  `status_reason` longtext,
  PRIMARY KEY (`id`),
  KEY `fk_rails_3e2b1c06bc` (`cluster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `clusters_applications_ingress` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cluster_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `status` int(11) NOT NULL,
  `ingress_type` int(11) NOT NULL,
  `version` varchar(255) NOT NULL,
  `cluster_ip` varchar(255) DEFAULT NULL,
  `status_reason` longtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `clusters_applications_prometheus` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cluster_id` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  `version` varchar(255) NOT NULL,
  `status_reason` mediumtext,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `fk_rails_557e773639` (`cluster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `cluster_platforms_kubernetes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cluster_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `api_url` longtext,
  `ca_cert` longtext,
  `namespace` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `encrypted_password` longtext,
  `encrypted_password_iv` varchar(255) DEFAULT NULL,
  `encrypted_token` longtext,
  `encrypted_token_iv` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_cluster_platforms_kubernetes_on_cluster_id` (`cluster_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `cluster_projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `cluster_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `index_cluster_projects_on_cluster_id` (`cluster_id`) USING BTREE,
  KEY `index_cluster_projects_on_project_id` (`project_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `cluster_providers_gcp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cluster_id` int(11) NOT NULL,
  `status` int(11) DEFAULT NULL,
  `num_nodes` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `status_reason` longtext,
  `gcp_project_id` varchar(255) NOT NULL,
  `zone` varchar(255) NOT NULL,
  `machine_type` varchar(255) DEFAULT NULL,
  `operation_id` varchar(255) DEFAULT NULL,
  `endpoint` varchar(255) DEFAULT NULL,
  `encrypted_access_token` longtext,
  `encrypted_access_token_iv` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_cluster_providers_gcp_on_cluster_id` (`cluster_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `container_repositories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_container_repositories_on_project_id_and_name` (`project_id`,`name`) USING BTREE,
  KEY `index_container_repositories_on_project_id` (`project_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `conversational_development_index_metrics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `leader_issues` float NOT NULL,
  `instance_issues` float NOT NULL,
  `leader_notes` float NOT NULL,
  `instance_notes` float NOT NULL,
  `leader_milestones` float NOT NULL,
  `instance_milestones` float NOT NULL,
  `leader_boards` float NOT NULL,
  `instance_boards` float NOT NULL,
  `leader_merge_requests` float NOT NULL,
  `instance_merge_requests` float NOT NULL,
  `leader_ci_pipelines` float NOT NULL,
  `instance_ci_pipelines` float NOT NULL,
  `leader_environments` float NOT NULL,
  `instance_environments` float NOT NULL,
  `leader_deployments` float NOT NULL,
  `instance_deployments` float NOT NULL,
  `leader_projects_prometheus_active` float NOT NULL,
  `instance_projects_prometheus_active` float NOT NULL,
  `leader_service_desk_issues` float NOT NULL,
  `instance_service_desk_issues` float NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `percentage_boards` float NOT NULL DEFAULT '0',
  `percentage_ci_pipelines` float NOT NULL DEFAULT '0',
  `percentage_deployments` float NOT NULL DEFAULT '0',
  `percentage_environments` float NOT NULL DEFAULT '0',
  `percentage_issues` float NOT NULL DEFAULT '0',
  `percentage_merge_requests` float NOT NULL DEFAULT '0',
  `percentage_milestones` float NOT NULL DEFAULT '0',
  `percentage_notes` float NOT NULL DEFAULT '0',
  `percentage_projects_prometheus_active` float NOT NULL DEFAULT '0',
  `percentage_service_desk_issues` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `deployments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `iid` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `environment_id` int(11) NOT NULL,
  `ref` varchar(255) NOT NULL,
  `tag` tinyint(1) NOT NULL,
  `sha` varchar(255) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `deployable_id` int(11) DEFAULT NULL,
  `deployable_type` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `on_stop` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_deployments_on_project_id_and_iid` (`project_id`,`iid`) USING BTREE,
  KEY `index_deployments_on_created_at` (`created_at`) USING BTREE,
  KEY `index_deployments_on_environment_id_and_id` (`environment_id`,`id`) USING BTREE,
  KEY `index_deployments_on_environment_id_and_iid_and_project_id` (`environment_id`,`iid`,`project_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `deploy_keys_projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `deploy_key_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `can_push` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_deploy_keys_projects_on_project_id` (`project_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `emails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `confirmation_token` varchar(255) DEFAULT NULL,
  `confirmed_at` datetime DEFAULT NULL,
  `confirmation_sent_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_emails_on_email` (`email`) USING BTREE,
  UNIQUE KEY `index_emails_on_confirmation_token` (`confirmation_token`) USING BTREE,
  KEY `index_emails_on_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `environments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `external_url` varchar(255) DEFAULT NULL,
  `environment_type` varchar(255) DEFAULT NULL,
  `state` varchar(255) NOT NULL DEFAULT 'available',
  `slug` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_environments_on_project_id_and_name` (`project_id`,`name`) USING BTREE,
  UNIQUE KEY `index_environments_on_project_id_and_slug` (`project_id`,`slug`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `author_id` int(11) NOT NULL,
  `target_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `action` smallint(6) NOT NULL,
  `target_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_events_on_action` (`action`) USING BTREE,
  KEY `index_events_on_author_id` (`author_id`) USING BTREE,
  KEY `index_events_on_project_id_and_id` (`project_id`,`id`) USING BTREE,
  KEY `index_events_on_target_type_and_target_id` (`target_type`,`target_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `features` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_features_on_key` (`key`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `feature_gates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `feature_key` varchar(255) NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_feature_gates_on_feature_key_and_key_and_value` (`feature_key`,`key`,`value`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `forked_project_links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `forked_to_project_id` int(11) NOT NULL,
  `forked_from_project_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_forked_project_links_on_forked_to_project_id` (`forked_to_project_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `fork_networks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `root_project_id` int(11) DEFAULT NULL,
  `deleted_root_project_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_fork_networks_on_root_project_id` (`root_project_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `fork_network_members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fork_network_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `forked_from_project_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_fork_network_members_on_project_id` (`project_id`) USING BTREE,
  KEY `index_fork_network_members_on_fork_network_id` (`fork_network_id`) USING BTREE,
  KEY `fk_b01280dae4` (`forked_from_project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `gcp_clusters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `service_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `gcp_cluster_size` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `enabled` tinyint(1) DEFAULT '1',
  `status_reason` longtext,
  `project_namespace` varchar(255) DEFAULT NULL,
  `endpoint` varchar(255) DEFAULT NULL,
  `ca_cert` longtext,
  `encrypted_kubernetes_token` longtext,
  `encrypted_kubernetes_token_iv` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `encrypted_password` longtext,
  `encrypted_password_iv` varchar(255) DEFAULT NULL,
  `gcp_project_id` varchar(255) NOT NULL,
  `gcp_cluster_zone` varchar(255) NOT NULL,
  `gcp_cluster_name` varchar(255) NOT NULL,
  `gcp_machine_type` varchar(255) DEFAULT NULL,
  `gcp_operation_id` varchar(255) DEFAULT NULL,
  `encrypted_gcp_token` longtext,
  `encrypted_gcp_token_iv` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_gcp_clusters_on_project_id` (`project_id`) USING BTREE,
  KEY `fk_rails_41d556eb65` (`service_id`),
  KEY `fk_rails_dc6f095aad` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `gpg_keys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `user_id` int(11) DEFAULT NULL,
  `primary_keyid` blob,
  `fingerprint` blob,
  `key` longtext,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_gpg_keys_on_fingerprint` (`fingerprint`(20)) USING BTREE,
  UNIQUE KEY `index_gpg_keys_on_primary_keyid` (`primary_keyid`(20)) USING BTREE,
  KEY `index_gpg_keys_on_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `gpg_key_subkeys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gpg_key_id` int(11) NOT NULL,
  `keyid` blob,
  `fingerprint` blob,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_gpg_key_subkeys_on_fingerprint` (`fingerprint`(20)) USING BTREE,
  UNIQUE KEY `index_gpg_key_subkeys_on_keyid` (`keyid`(20)) USING BTREE,
  KEY `index_gpg_key_subkeys_on_gpg_key_id` (`gpg_key_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `gpg_signatures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `project_id` int(11) DEFAULT NULL,
  `gpg_key_id` int(11) DEFAULT NULL,
  `commit_sha` blob,
  `gpg_key_primary_keyid` blob,
  `gpg_key_user_name` longtext,
  `gpg_key_user_email` longtext,
  `verification_status` smallint(6) NOT NULL DEFAULT '0',
  `gpg_key_subkey_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_gpg_signatures_on_commit_sha` (`commit_sha`(20)) USING BTREE,
  KEY `index_gpg_signatures_on_gpg_key_id` (`gpg_key_id`) USING BTREE,
  KEY `index_gpg_signatures_on_gpg_key_primary_keyid` (`gpg_key_primary_keyid`(20)) USING BTREE,
  KEY `index_gpg_signatures_on_gpg_key_subkey_id` (`gpg_key_subkey_id`) USING BTREE,
  KEY `index_gpg_signatures_on_project_id` (`project_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `group_custom_attributes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `group_id` int(11) NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_group_custom_attributes_on_group_id_and_key` (`group_id`,`key`) USING BTREE,
  KEY `index_group_custom_attributes_on_key_and_value` (`key`,`value`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `identities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `extern_uid` varchar(255) DEFAULT NULL,
  `provider` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_identities_on_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `issues` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `author_id` int(11) DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `description` longtext,
  `milestone_id` int(11) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `iid` int(11) DEFAULT NULL,
  `updated_by_id` int(11) DEFAULT NULL,
  `confidential` tinyint(1) NOT NULL DEFAULT '0',
  `due_date` date DEFAULT NULL,
  `moved_to_id` int(11) DEFAULT NULL,
  `lock_version` int(11) DEFAULT NULL,
  `title_html` longtext,
  `description_html` longtext,
  `time_estimate` int(11) DEFAULT NULL,
  `relative_position` int(11) DEFAULT NULL,
  `cached_markdown_version` int(11) DEFAULT NULL,
  `last_edited_at` datetime DEFAULT NULL,
  `last_edited_by_id` int(11) DEFAULT NULL,
  `discussion_locked` tinyint(1) DEFAULT NULL,
  `closed_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_issues_on_project_id_and_iid` (`project_id`,`iid`) USING BTREE,
  KEY `index_issues_on_author_id` (`author_id`) USING BTREE,
  KEY `index_issues_on_confidential` (`confidential`) USING BTREE,
  KEY `index_issues_on_milestone_id` (`milestone_id`) USING BTREE,
  KEY `index_issues_on_project_id_and_created_at_and_id_and_state` (`project_id`,`created_at`,`id`,`state`) USING BTREE,
  KEY `index_issues_on_project_id_and_updated_at_and_id_and_state` (`project_id`,`updated_at`,`id`,`state`) USING BTREE,
  KEY `index_issues_on_relative_position` (`relative_position`) USING BTREE,
  KEY `index_issues_on_state` (`state`) USING BTREE,
  KEY `index_issues_on_updated_by_id` (`updated_by_id`),
  KEY `index_issues_on_moved_to_id` (`moved_to_id`),
  KEY `idx_issues_on_project_id_and_due_date_and_id_and_state_partial` (`project_id`,`due_date`,`id`,`state`),
  KEY `index_issues_on_updated_at` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `issue_assignees` (
  `user_id` int(11) NOT NULL,
  `issue_id` int(11) NOT NULL,
  UNIQUE KEY `index_issue_assignees_on_issue_id_and_user_id` (`issue_id`,`user_id`) USING BTREE,
  KEY `index_issue_assignees_on_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `issue_metrics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `issue_id` int(11) NOT NULL,
  `first_mentioned_in_commit_at` datetime DEFAULT NULL,
  `first_associated_with_milestone_at` datetime DEFAULT NULL,
  `first_added_to_board_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_issue_metrics` (`issue_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `keys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `key` longtext,
  `title` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `fingerprint` varchar(255) DEFAULT NULL,
  `public` tinyint(1) NOT NULL DEFAULT '0',
  `last_used_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_keys_on_fingerprint` (`fingerprint`) USING BTREE,
  KEY `index_keys_on_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `labels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `color` varchar(255) DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `template` tinyint(1) DEFAULT '0',
  `description` varchar(255) DEFAULT NULL,
  `description_html` longtext,
  `type` varchar(255) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  `cached_markdown_version` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_labels_on_group_id_and_project_id_and_title` (`group_id`,`project_id`,`title`) USING BTREE,
  KEY `index_labels_on_project_id` (`project_id`) USING BTREE,
  KEY `index_labels_on_template` (`template`) USING BTREE,
  KEY `index_labels_on_title` (`title`) USING BTREE,
  KEY `index_labels_on_type_and_project_id` (`type`,`project_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `label_links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label_id` int(11) DEFAULT NULL,
  `target_id` int(11) DEFAULT NULL,
  `target_type` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_label_links_on_label_id` (`label_id`) USING BTREE,
  KEY `index_label_links_on_target_id_and_target_type` (`target_id`,`target_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `label_priorities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `label_id` int(11) NOT NULL,
  `priority` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_label_priorities_on_project_id_and_label_id` (`project_id`,`label_id`) USING BTREE,
  KEY `index_label_priorities_on_priority` (`priority`) USING BTREE,
  KEY `fk_rails_e161058b0f` (`label_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `lfs_file_locks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `path` varchar(255) DEFAULT NULL, -- Project Factory: reduced from 511 to 255 for compatibility with MySQL < 5.5
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_lfs_file_locks_on_project_id_and_path` (`project_id`,`path`),
  KEY `index_lfs_file_locks_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `lfs_objects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `oid` varchar(255) NOT NULL,
  `size` bigint(20) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `file` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_lfs_objects_on_oid` (`oid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `lfs_objects_projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lfs_object_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_lfs_objects_projects_on_project_id` (`project_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `lists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `board_id` int(11) NOT NULL,
  `label_id` int(11) DEFAULT NULL,
  `list_type` int(11) NOT NULL DEFAULT '1',
  `position` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_lists_on_board_id_and_label_id` (`board_id`,`label_id`) USING BTREE,
  KEY `index_lists_on_label_id` (`label_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `access_level` int(11) NOT NULL,
  `source_id` int(11) NOT NULL,
  `source_type` varchar(255) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `notification_level` int(11) NOT NULL,
  `type` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `invite_email` varchar(255) DEFAULT NULL,
  `invite_token` varchar(255) DEFAULT NULL,
  `invite_accepted_at` datetime DEFAULT NULL,
  `requested_at` datetime DEFAULT NULL,
  `expires_at` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_members_on_invite_token` (`invite_token`) USING BTREE,
  KEY `index_members_on_access_level` (`access_level`) USING BTREE,
  KEY `index_members_on_requested_at` (`requested_at`) USING BTREE,
  KEY `index_members_on_source_id_and_source_type` (`source_id`,`source_type`) USING BTREE,
  KEY `index_members_on_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `merge_requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `target_branch` varchar(255) NOT NULL,
  `source_branch` varchar(255) NOT NULL,
  `source_project_id` int(11) DEFAULT NULL,
  `author_id` int(11) DEFAULT NULL,
  `assignee_id` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `milestone_id` int(11) DEFAULT NULL,
  `state` varchar(255) NOT NULL DEFAULT 'opened',
  `merge_status` varchar(255) NOT NULL DEFAULT 'unchecked',
  `target_project_id` int(11) NOT NULL,
  `iid` int(11) DEFAULT NULL,
  `description` longtext,
  `updated_by_id` int(11) DEFAULT NULL,
  `merge_error` longtext,
  `merge_params` longtext,
  `merge_when_pipeline_succeeds` tinyint(1) NOT NULL DEFAULT '0',
  `merge_user_id` int(11) DEFAULT NULL,
  `merge_commit_sha` varchar(255) DEFAULT NULL,
  `in_progress_merge_commit_sha` varchar(255) DEFAULT NULL,
  `lock_version` int(11) DEFAULT NULL,
  `title_html` longtext,
  `description_html` longtext,
  `time_estimate` int(11) DEFAULT NULL,
  `cached_markdown_version` int(11) DEFAULT NULL,
  `last_edited_at` datetime DEFAULT NULL,
  `last_edited_by_id` int(11) DEFAULT NULL,
  `head_pipeline_id` int(11) DEFAULT NULL,
  `merge_jid` varchar(255) DEFAULT NULL,
  `discussion_locked` tinyint(1) DEFAULT NULL,
  `latest_merge_request_diff_id` int(11) DEFAULT NULL,
  `rebase_commit_sha` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_merge_requests_on_target_project_id_and_iid` (`target_project_id`,`iid`) USING BTREE,
  KEY `index_merge_requests_on_assignee_id` (`assignee_id`) USING BTREE,
  KEY `index_merge_requests_on_author_id` (`author_id`) USING BTREE,
  KEY `index_merge_requests_on_created_at` (`created_at`) USING BTREE,
  KEY `index_merge_requests_on_head_pipeline_id` (`head_pipeline_id`) USING BTREE,
  KEY `index_merge_requests_on_latest_merge_request_diff_id` (`latest_merge_request_diff_id`) USING BTREE,
  KEY `index_merge_requests_on_milestone_id` (`milestone_id`) USING BTREE,
  KEY `index_merge_requests_on_source_branch` (`source_branch`) USING BTREE,
  KEY `index_merge_requests_on_source_project_id_and_source_branch` (`source_project_id`,`source_branch`) USING BTREE,
  KEY `index_merge_requests_on_target_branch` (`target_branch`) USING BTREE,
  KEY `index_merge_requests_on_tp_id_and_merge_commit_sha_and_id` (`target_project_id`,`merge_commit_sha`,`id`) USING BTREE,
  KEY `index_merge_requests_on_title` (`title`) USING BTREE,
  KEY `index_merge_requests_on_updated_by_id` (`updated_by_id`),
  KEY `index_merge_requests_on_merge_user_id` (`merge_user_id`),
  KEY `index_merge_requests_on_source_project_and_branch_state_opened` (`source_project_id`,`source_branch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `merge_requests_closing_issues` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `merge_request_id` int(11) NOT NULL,
  `issue_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_merge_requests_closing_issues_on_issue_id` (`issue_id`) USING BTREE,
  KEY `index_merge_requests_closing_issues_on_merge_request_id` (`merge_request_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `merge_request_diffs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `state` varchar(255) DEFAULT NULL,
  `merge_request_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `base_commit_sha` varchar(255) DEFAULT NULL,
  `real_size` varchar(255) DEFAULT NULL,
  `head_commit_sha` varchar(255) DEFAULT NULL,
  `start_commit_sha` varchar(255) DEFAULT NULL,
  `commits_count` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_merge_request_diffs_on_merge_request_id_and_id` (`merge_request_id`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `merge_request_diff_commits` (
  `authored_date` timestamp NULL DEFAULT NULL,
  `committed_date` timestamp NULL DEFAULT NULL,
  `merge_request_diff_id` int(11) NOT NULL,
  `relative_order` int(11) NOT NULL,
  `sha` blob NOT NULL,
  `author_name` longtext,
  `author_email` longtext,
  `committer_name` longtext,
  `committer_email` longtext,
  `message` longtext,
  UNIQUE KEY `index_merge_request_diff_commits_on_mr_diff_id_and_order` (`merge_request_diff_id`,`relative_order`) USING BTREE,
  KEY `index_merge_request_diff_commits_on_sha` (`sha`(20))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `merge_request_diff_files` (
  `merge_request_diff_id` int(11) NOT NULL,
  `relative_order` int(11) NOT NULL,
  `new_file` tinyint(1) NOT NULL,
  `renamed_file` tinyint(1) NOT NULL,
  `deleted_file` tinyint(1) NOT NULL,
  `too_large` tinyint(1) NOT NULL,
  `a_mode` varchar(255) NOT NULL,
  `b_mode` varchar(255) NOT NULL,
  `new_path` longtext NOT NULL,
  `old_path` longtext NOT NULL,
  `diff` longtext NOT NULL,
  `binary` tinyint(1) DEFAULT NULL,
  UNIQUE KEY `index_merge_request_diff_files_on_mr_diff_id_and_order` (`merge_request_diff_id`,`relative_order`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `merge_request_metrics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `merge_request_id` int(11) NOT NULL,
  `latest_build_started_at` datetime DEFAULT NULL,
  `latest_build_finished_at` datetime DEFAULT NULL,
  `first_deployed_to_production_at` datetime DEFAULT NULL,
  `merged_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `pipeline_id` int(11) DEFAULT NULL,
  `merged_by_id` int(11) DEFAULT NULL,
  `latest_closed_by_id` int(11) DEFAULT NULL,
  `latest_closed_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_merge_request_metrics_on_first_deployed_to_production_at` (`first_deployed_to_production_at`) USING BTREE,
  KEY `index_merge_request_metrics` (`merge_request_id`) USING BTREE,
  KEY `index_merge_request_metrics_on_pipeline_id` (`pipeline_id`) USING BTREE,
  KEY `fk_rails_7f28d925f3` (`merged_by_id`),
  KEY `fk_rails_ae440388cc` (`latest_closed_by_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `milestones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `project_id` int(11) DEFAULT NULL,
  `description` longtext,
  `due_date` date DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `iid` int(11) DEFAULT NULL,
  `title_html` longtext,
  `description_html` longtext,
  `start_date` date DEFAULT NULL,
  `cached_markdown_version` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_milestones_on_project_id_and_iid` (`project_id`,`iid`) USING BTREE,
  KEY `index_milestones_on_due_date` (`due_date`) USING BTREE,
  KEY `index_milestones_on_group_id` (`group_id`) USING BTREE,
  KEY `index_milestones_on_title` (`title`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `namespaces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `path` varchar(255) NOT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `description` varchar(255) NOT NULL DEFAULT '',
  `avatar` varchar(255) DEFAULT NULL,
  `share_with_group_lock` tinyint(1) DEFAULT '0',
  `visibility_level` int(11) NOT NULL DEFAULT '20',
  `request_access_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `description_html` longtext,
  `lfs_enabled` tinyint(1) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `require_two_factor_authentication` tinyint(1) NOT NULL DEFAULT '0',
  `two_factor_grace_period` int(11) NOT NULL DEFAULT '48',
  `cached_markdown_version` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_namespaces_on_name_and_parent_id` (`name`,`parent_id`) USING BTREE,
  UNIQUE KEY `index_namespaces_on_parent_id_and_id` (`parent_id`,`id`) USING BTREE,
  KEY `index_namespaces_on_created_at` (`created_at`) USING BTREE,
  KEY `index_namespaces_on_owner_id` (`owner_id`) USING BTREE,
  KEY `index_namespaces_on_path` (`path`) USING BTREE,
  KEY `index_namespaces_on_require_two_factor_authentication` (`require_two_factor_authentication`) USING BTREE,
  KEY `index_namespaces_on_type` (`type`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `note` longtext,
  `noteable_type` varchar(255) DEFAULT NULL,
  `author_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `attachment` varchar(255) DEFAULT NULL,
  `line_code` varchar(255) DEFAULT NULL,
  `commit_id` varchar(255) DEFAULT NULL,
  `noteable_id` int(11) DEFAULT NULL,
  `system` tinyint(1) NOT NULL DEFAULT '0',
  `st_diff` longtext,
  `updated_by_id` int(11) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `position` longtext,
  `original_position` longtext,
  `resolved_at` datetime DEFAULT NULL,
  `resolved_by_id` int(11) DEFAULT NULL,
  `discussion_id` varchar(255) DEFAULT NULL,
  `note_html` longtext,
  `cached_markdown_version` int(11) DEFAULT NULL,
  `change_position` longtext,
  `resolved_by_push` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_notes_on_author_id` (`author_id`) USING BTREE,
  KEY `index_notes_on_commit_id` (`commit_id`) USING BTREE,
  KEY `index_notes_on_created_at` (`created_at`) USING BTREE,
  KEY `index_notes_on_discussion_id` (`discussion_id`) USING BTREE,
  KEY `index_notes_on_line_code` (`line_code`) USING BTREE,
  KEY `index_notes_on_noteable_id_and_noteable_type` (`noteable_id`,`noteable_type`) USING BTREE,
  KEY `index_notes_on_noteable_type` (`noteable_type`) USING BTREE,
  KEY `index_notes_on_project_id_and_noteable_type` (`project_id`,`noteable_type`) USING BTREE,
  KEY `index_notes_on_updated_at` (`updated_at`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `notification_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `source_id` int(11) DEFAULT NULL,
  `source_type` varchar(255) DEFAULT NULL,
  `level` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `new_note` tinyint(1) DEFAULT NULL,
  `new_issue` tinyint(1) DEFAULT NULL,
  `reopen_issue` tinyint(1) DEFAULT NULL,
  `close_issue` tinyint(1) DEFAULT NULL,
  `reassign_issue` tinyint(1) DEFAULT NULL,
  `new_merge_request` tinyint(1) DEFAULT NULL,
  `reopen_merge_request` tinyint(1) DEFAULT NULL,
  `close_merge_request` tinyint(1) DEFAULT NULL,
  `reassign_merge_request` tinyint(1) DEFAULT NULL,
  `merge_merge_request` tinyint(1) DEFAULT NULL,
  `failed_pipeline` tinyint(1) DEFAULT NULL,
  `success_pipeline` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_notifications_on_user_id_and_source_id_and_source_type` (`user_id`,`source_id`,`source_type`) USING BTREE,
  KEY `index_notification_settings_on_source_id_and_source_type` (`source_id`,`source_type`) USING BTREE,
  KEY `index_notification_settings_on_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `oauth_access_grants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_owner_id` int(11) NOT NULL,
  `application_id` int(11) NOT NULL,
  `token` varchar(255) NOT NULL,
  `expires_in` int(11) NOT NULL,
  `redirect_uri` longtext NOT NULL,
  `created_at` datetime NOT NULL,
  `revoked_at` datetime DEFAULT NULL,
  `scopes` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_oauth_access_grants_on_token` (`token`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `oauth_access_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_owner_id` int(11) DEFAULT NULL,
  `application_id` int(11) DEFAULT NULL,
  `token` varchar(255) NOT NULL,
  `refresh_token` varchar(255) DEFAULT NULL,
  `expires_in` int(11) DEFAULT NULL,
  `revoked_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `scopes` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_oauth_access_tokens_on_token` (`token`) USING BTREE,
  UNIQUE KEY `index_oauth_access_tokens_on_refresh_token` (`refresh_token`) USING BTREE,
  KEY `index_oauth_access_tokens_on_resource_owner_id` (`resource_owner_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `oauth_applications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `uid` varchar(255) NOT NULL,
  `secret` varchar(255) NOT NULL,
  `redirect_uri` longtext NOT NULL,
  `scopes` varchar(255) NOT NULL DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `owner_type` varchar(255) DEFAULT NULL,
  `trusted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_oauth_applications_on_uid` (`uid`) USING BTREE,
  KEY `index_oauth_applications_on_owner_id_and_owner_type` (`owner_id`,`owner_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `oauth_openid_requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `access_grant_id` int(11) NOT NULL,
  `nonce` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_oauth_openid_requests_oauth_access_grants_access_grant_id` (`access_grant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `pages_domains` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `certificate` longtext,
  `encrypted_key` longtext,
  `encrypted_key_iv` varchar(255) DEFAULT NULL,
  `encrypted_key_salt` varchar(255) DEFAULT NULL,
  `domain` varchar(255) DEFAULT NULL,
  `verified_at` timestamp NULL DEFAULT NULL,
  `verification_code` varchar(255) NOT NULL,
  `enabled_until` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_pages_domains_on_domain` (`domain`) USING BTREE,
  KEY `index_pages_domains_on_project_id` (`project_id`) USING BTREE,
  KEY `index_pages_domains_on_verified_at` (`verified_at`),
  KEY `index_pages_domains_on_project_id_and_enabled_until` (`project_id`,`enabled_until`),
  KEY `index_pages_domains_on_verified_at_and_enabled_until` (`verified_at`,`enabled_until`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `personal_access_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `token` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `revoked` tinyint(1) DEFAULT '0',
  `expires_at` date DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `scopes` varchar(255) NOT NULL DEFAULT '--- []\n',
  `impersonation` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_personal_access_tokens_on_token` (`token`) USING BTREE,
  KEY `index_personal_access_tokens_on_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `path` varchar(255) DEFAULT NULL,
  `description` longtext,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `creator_id` int(11) DEFAULT NULL,
  `namespace_id` int(11) DEFAULT NULL,
  `last_activity_at` datetime DEFAULT NULL,
  `import_url` varchar(255) DEFAULT NULL,
  `visibility_level` int(11) NOT NULL DEFAULT '0',
  `archived` tinyint(1) NOT NULL DEFAULT '0',
  `avatar` varchar(255) DEFAULT NULL,
  `import_status` varchar(255) DEFAULT NULL,
  `star_count` int(11) NOT NULL DEFAULT '0',
  `import_type` varchar(255) DEFAULT NULL,
  `import_source` varchar(255) DEFAULT NULL,
  `import_error` longtext,
  `ci_id` int(11) DEFAULT NULL,
  `shared_runners_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `runners_token` varchar(255) DEFAULT NULL,
  `build_coverage_regex` varchar(255) DEFAULT NULL,
  `build_allow_git_fetch` tinyint(1) NOT NULL DEFAULT '1',
  `build_timeout` int(11) NOT NULL DEFAULT '3600',
  `pending_delete` tinyint(1) DEFAULT '0',
  `public_builds` tinyint(1) NOT NULL DEFAULT '1',
  `last_repository_check_failed` tinyint(1) DEFAULT NULL,
  `last_repository_check_at` datetime DEFAULT NULL,
  `container_registry_enabled` tinyint(1) DEFAULT NULL,
  `only_allow_merge_if_pipeline_succeeds` tinyint(1) NOT NULL DEFAULT '0',
  `has_external_issue_tracker` tinyint(1) DEFAULT NULL,
  `repository_storage` varchar(255) NOT NULL DEFAULT 'default',
  `request_access_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `has_external_wiki` tinyint(1) DEFAULT NULL,
  `ci_config_path` varchar(255) DEFAULT NULL,
  `lfs_enabled` tinyint(1) DEFAULT NULL,
  `description_html` longtext,
  `only_allow_merge_if_all_discussions_are_resolved` tinyint(1) DEFAULT NULL,
  `printing_merge_request_link_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `auto_cancel_pending_pipelines` int(11) NOT NULL DEFAULT '1',
  `import_jid` varchar(255) DEFAULT NULL,
  `cached_markdown_version` int(11) DEFAULT NULL,
  `delete_error` longtext,
  `last_repository_updated_at` datetime DEFAULT NULL,
  `storage_version` smallint(6) DEFAULT NULL,
  `resolve_outdated_diff_discussions` tinyint(1) DEFAULT NULL,
  `repository_read_only` tinyint(1) DEFAULT NULL,
  `merge_requests_ff_only_enabled` tinyint(1) DEFAULT '0',
  `merge_requests_rebase_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `jobs_cache_index` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_projects_on_id_partial_for_visibility` (`id`),
  KEY `index_projects_on_ci_id` (`ci_id`) USING BTREE,
  KEY `index_projects_on_created_at` (`created_at`) USING BTREE,
  KEY `index_projects_on_creator_id` (`creator_id`) USING BTREE,
  KEY `index_projects_on_last_activity_at` (`last_activity_at`) USING BTREE,
  KEY `index_projects_on_last_repository_check_failed` (`last_repository_check_failed`) USING BTREE,
  KEY `index_projects_on_last_repository_updated_at` (`last_repository_updated_at`) USING BTREE,
  KEY `index_projects_on_namespace_id` (`namespace_id`) USING BTREE,
  KEY `index_projects_on_path` (`path`) USING BTREE,
  KEY `index_projects_on_pending_delete` (`pending_delete`) USING BTREE,
  KEY `index_projects_on_repository_storage` (`repository_storage`) USING BTREE,
  KEY `index_projects_on_runners_token` (`runners_token`) USING BTREE,
  KEY `index_projects_on_star_count` (`star_count`) USING BTREE,
  KEY `index_projects_on_visibility_level` (`visibility_level`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `project_authorizations` (
  `user_id` int(11) DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `access_level` int(11) DEFAULT NULL,
  UNIQUE KEY `index_project_authorizations_on_user_id_project_id_access_level` (`user_id`,`project_id`,`access_level`) USING BTREE,
  KEY `index_project_authorizations_on_project_id` (`project_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `project_auto_devops` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `enabled` tinyint(1) DEFAULT NULL,
  `domain` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_project_auto_devops_on_project_id` (`project_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `project_custom_attributes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `project_id` int(11) NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_project_custom_attributes_on_project_id_and_key` (`project_id`,`key`) USING BTREE,
  KEY `index_project_custom_attributes_on_key_and_value` (`key`,`value`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `project_features` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `merge_requests_access_level` int(11) DEFAULT NULL,
  `issues_access_level` int(11) DEFAULT NULL,
  `wiki_access_level` int(11) DEFAULT NULL,
  `snippets_access_level` int(11) DEFAULT NULL,
  `builds_access_level` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `repository_access_level` int(11) NOT NULL DEFAULT '20',
  PRIMARY KEY (`id`),
  KEY `index_project_features_on_project_id` (`project_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `project_group_links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `group_access` int(11) NOT NULL DEFAULT '30',
  `expires_at` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_project_group_links_on_group_id` (`group_id`) USING BTREE,
  KEY `index_project_group_links_on_project_id` (`project_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `project_import_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `data` longtext,
  `encrypted_credentials` longtext,
  `encrypted_credentials_iv` varchar(255) DEFAULT NULL,
  `encrypted_credentials_salt` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_project_import_data_on_project_id` (`project_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `project_statistics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `namespace_id` int(11) NOT NULL,
  `commit_count` bigint(20) NOT NULL DEFAULT '0',
  `storage_size` bigint(20) NOT NULL DEFAULT '0',
  `repository_size` bigint(20) NOT NULL DEFAULT '0',
  `lfs_objects_size` bigint(20) NOT NULL DEFAULT '0',
  `build_artifacts_size` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_project_statistics_on_project_id` (`project_id`) USING BTREE,
  KEY `index_project_statistics_on_namespace_id` (`namespace_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `protected_branches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_protected_branches_on_project_id` (`project_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `protected_branch_merge_access_levels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `protected_branch_id` int(11) NOT NULL,
  `access_level` int(11) NOT NULL DEFAULT '40',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_protected_branch_merge_access` (`protected_branch_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `protected_branch_push_access_levels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `protected_branch_id` int(11) NOT NULL,
  `access_level` int(11) NOT NULL DEFAULT '40',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_protected_branch_push_access` (`protected_branch_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `protected_tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_protected_tags_on_project_id` (`project_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `protected_tag_create_access_levels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `protected_tag_id` int(11) NOT NULL,
  `access_level` int(11) DEFAULT '40',
  `user_id` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_protected_tag_create_access` (`protected_tag_id`) USING BTREE,
  KEY `index_protected_tag_create_access_levels_on_user_id` (`user_id`) USING BTREE,
  KEY `fk_rails_b4eb82fe3c` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `push_event_payloads` (
  `commit_count` bigint(20) NOT NULL,
  `event_id` int(11) NOT NULL,
  `action` smallint(6) NOT NULL,
  `ref_type` smallint(6) NOT NULL,
  `commit_from` blob,
  `commit_to` blob,
  `ref` longtext,
  `commit_title` varchar(70) DEFAULT NULL,
  UNIQUE KEY `index_push_event_payloads_on_event_id` (`event_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `redirect_routes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `source_id` int(11) NOT NULL,
  `source_type` varchar(255) NOT NULL,
  `path` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `permanent` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_redirect_routes_on_path` (`path`) USING BTREE,
  KEY `index_redirect_routes_on_source_type_and_source_id` (`source_type`,`source_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `releases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag` varchar(255) DEFAULT NULL,
  `description` longtext,
  `project_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `description_html` longtext,
  `cached_markdown_version` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_releases_on_project_id_and_tag` (`project_id`,`tag`) USING BTREE,
  KEY `index_releases_on_project_id` (`project_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `routes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `source_id` int(11) NOT NULL,
  `source_type` varchar(255) NOT NULL,
  `path` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_routes_on_path` (`path`) USING BTREE,
  UNIQUE KEY `index_routes_on_source_type_and_source_id` (`source_type`,`source_id`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `sent_notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `noteable_id` int(11) DEFAULT NULL,
  `noteable_type` varchar(255) DEFAULT NULL,
  `recipient_id` int(11) DEFAULT NULL,
  `commit_id` varchar(255) DEFAULT NULL,
  `reply_key` varchar(255) NOT NULL,
  `line_code` varchar(255) DEFAULT NULL,
  `note_type` varchar(255) DEFAULT NULL,
  `position` longtext,
  `in_reply_to_discussion_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_sent_notifications_on_reply_key` (`reply_key`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `services` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '0',
  `properties` longtext,
  `template` tinyint(1) DEFAULT '0',
  `push_events` tinyint(1) DEFAULT '1',
  `issues_events` tinyint(1) DEFAULT '1',
  `merge_requests_events` tinyint(1) DEFAULT '1',
  `tag_push_events` tinyint(1) DEFAULT '1',
  `note_events` tinyint(1) NOT NULL DEFAULT '1',
  `category` varchar(255) NOT NULL DEFAULT 'common',
  `default` tinyint(1) DEFAULT '0',
  `wiki_page_events` tinyint(1) DEFAULT '1',
  `pipeline_events` tinyint(1) NOT NULL DEFAULT '0',
  `confidential_issues_events` tinyint(1) NOT NULL DEFAULT '1',
  `commit_events` tinyint(1) NOT NULL DEFAULT '1',
  `job_events` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_services_on_project_id` (`project_id`) USING BTREE,
  KEY `index_services_on_template` (`template`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `snippets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `content` longtext,
  `author_id` int(11) NOT NULL,
  `project_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `file_name` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `visibility_level` int(11) NOT NULL DEFAULT '0',
  `title_html` longtext,
  `content_html` longtext,
  `cached_markdown_version` int(11) DEFAULT NULL,
  `description` longtext,
  `description_html` longtext,
  PRIMARY KEY (`id`),
  KEY `index_snippets_on_author_id` (`author_id`) USING BTREE,
  KEY `index_snippets_on_project_id` (`project_id`) USING BTREE,
  KEY `index_snippets_on_updated_at` (`updated_at`) USING BTREE,
  KEY `index_snippets_on_visibility_level` (`visibility_level`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `spam_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `source_ip` varchar(255) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `via_api` tinyint(1) DEFAULT NULL,
  `noteable_type` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` longtext,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `submitted_as_ham` tinyint(1) NOT NULL DEFAULT '0',
  `recaptcha_verified` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `subscriptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `subscribable_id` int(11) DEFAULT NULL,
  `subscribable_type` varchar(255) DEFAULT NULL,
  `subscribed` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_subscriptions_on_subscribable_and_user_id_and_project_id` (`subscribable_id`,`subscribable_type`,`user_id`,`project_id`) USING BTREE,
  KEY `fk_rails_d0c8bda804` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `system_note_metadata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `note_id` int(11) NOT NULL,
  `commit_count` int(11) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_system_note_metadata_on_note_id` (`note_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `taggings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_id` int(11) DEFAULT NULL,
  `taggable_id` int(11) DEFAULT NULL,
  `taggable_type` varchar(255) DEFAULT NULL,
  `tagger_id` int(11) DEFAULT NULL,
  `tagger_type` varchar(255) DEFAULT NULL,
  `context` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `taggings_idx` (`tag_id`,`taggable_id`,`taggable_type`,`context`,`tagger_id`,`tagger_type`) USING BTREE,
  KEY `index_taggings_on_taggable_id_and_taggable_type_and_context` (`taggable_id`,`taggable_type`,`context`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `taggings_count` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_tags_on_name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `timelogs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time_spent` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `issue_id` int(11) DEFAULT NULL,
  `merge_request_id` int(11) DEFAULT NULL,
  `spent_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_timelogs_on_issue_id` (`issue_id`) USING BTREE,
  KEY `index_timelogs_on_merge_request_id` (`merge_request_id`) USING BTREE,
  KEY `index_timelogs_on_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `todos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `target_id` int(11) DEFAULT NULL,
  `target_type` varchar(255) NOT NULL,
  `author_id` int(11) NOT NULL,
  `action` int(11) NOT NULL,
  `state` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `note_id` int(11) DEFAULT NULL,
  `commit_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_todos_on_author_id` (`author_id`) USING BTREE,
  KEY `index_todos_on_commit_id` (`commit_id`) USING BTREE,
  KEY `index_todos_on_note_id` (`note_id`) USING BTREE,
  KEY `index_todos_on_project_id` (`project_id`) USING BTREE,
  KEY `index_todos_on_target_type_and_target_id` (`target_type`,`target_id`) USING BTREE,
  KEY `index_todos_on_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `trending_projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_trending_projects_on_project_id` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `u2f_registrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `certificate` longtext,
  `key_handle` varchar(255) DEFAULT NULL,
  `public_key` varchar(255) DEFAULT NULL,
  `counter` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_u2f_registrations_on_key_handle` (`key_handle`) USING BTREE,
  KEY `index_u2f_registrations_on_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `uploads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `size` bigint(20) NOT NULL,
  `path` varchar(255) NOT NULL, -- Project Factory: reduced from 511 to 255 for compatibility with MySQL < 5.5
  `checksum` varchar(64) DEFAULT NULL,
  `model_id` int(11) DEFAULT NULL,
  `model_type` varchar(255) DEFAULT NULL,
  `uploader` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `mount_point` varchar(255) DEFAULT NULL,
  `secret` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_uploads_on_checksum` (`checksum`) USING BTREE,
  KEY `index_uploads_on_model_id_and_model_type` (`model_id`,`model_type`) USING BTREE,
  KEY `index_uploads_on_uploader_and_path` (`uploader`,`path`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) DEFAULT NULL,
  `last_sign_in_ip` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `admin` tinyint(1) NOT NULL DEFAULT '0',
  `projects_limit` int(11) NOT NULL,
  `skype` varchar(255) NOT NULL DEFAULT '',
  `linkedin` varchar(255) NOT NULL DEFAULT '',
  `twitter` varchar(255) NOT NULL DEFAULT '',
  `bio` varchar(255) DEFAULT NULL,
  `failed_attempts` int(11) DEFAULT '0',
  `locked_at` datetime DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `can_create_group` tinyint(1) NOT NULL DEFAULT '1',
  `can_create_team` tinyint(1) NOT NULL DEFAULT '1',
  `state` varchar(255) DEFAULT NULL,
  `color_scheme_id` int(11) NOT NULL DEFAULT '1',
  `password_expires_at` datetime DEFAULT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `last_credential_check_at` datetime DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `confirmation_token` varchar(255) DEFAULT NULL,
  `confirmed_at` datetime DEFAULT NULL,
  `confirmation_sent_at` datetime DEFAULT NULL,
  `unconfirmed_email` varchar(255) DEFAULT NULL,
  `hide_no_ssh_key` tinyint(1) DEFAULT '0',
  `website_url` varchar(255) NOT NULL DEFAULT '',
  `notification_email` varchar(255) DEFAULT NULL,
  `hide_no_password` tinyint(1) DEFAULT '0',
  `password_automatically_set` tinyint(1) DEFAULT '0',
  `location` varchar(255) DEFAULT NULL,
  `encrypted_otp_secret` varchar(255) DEFAULT NULL,
  `encrypted_otp_secret_iv` varchar(255) DEFAULT NULL,
  `encrypted_otp_secret_salt` varchar(255) DEFAULT NULL,
  `otp_required_for_login` tinyint(1) NOT NULL DEFAULT '0',
  `otp_backup_codes` longtext,
  `public_email` varchar(255) NOT NULL DEFAULT '',
  `dashboard` int(11) DEFAULT '0',
  `project_view` int(11) DEFAULT '0',
  `consumed_timestep` int(11) DEFAULT NULL,
  `layout` int(11) DEFAULT '0',
  `hide_project_limit` tinyint(1) DEFAULT '0',
  `unlock_token` varchar(255) DEFAULT NULL,
  `otp_grace_period_started_at` datetime DEFAULT NULL,
  `external` tinyint(1) DEFAULT '0',
  `incoming_email_token` varchar(255) DEFAULT NULL,
  `organization` varchar(255) DEFAULT NULL,
  `require_two_factor_authentication_from_group` tinyint(1) NOT NULL DEFAULT '0',
  `two_factor_grace_period` int(11) NOT NULL DEFAULT '48',
  `ghost` tinyint(1) DEFAULT NULL,
  `last_activity_on` date DEFAULT NULL,
  `notified_of_own_activity` tinyint(1) DEFAULT NULL,
  `preferred_language` varchar(255) DEFAULT NULL,
  `rss_token` varchar(255) DEFAULT NULL,
  `theme_id` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`) USING BTREE,
  UNIQUE KEY `index_users_on_confirmation_token` (`confirmation_token`) USING BTREE,
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`) USING BTREE,
  KEY `index_users_on_admin` (`admin`) USING BTREE,
  KEY `index_users_on_created_at` (`created_at`) USING BTREE,
  KEY `index_users_on_ghost` (`ghost`) USING BTREE,
  KEY `index_users_on_incoming_email_token` (`incoming_email_token`) USING BTREE,
  KEY `index_users_on_name` (`name`) USING BTREE,
  KEY `index_users_on_rss_token` (`rss_token`) USING BTREE,
  KEY `index_users_on_state` (`state`) USING BTREE,
  KEY `index_users_on_username` (`username`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `users_star_projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_star_projects_on_user_id_and_project_id` (`user_id`,`project_id`) USING BTREE,
  KEY `index_users_star_projects_on_project_id` (`project_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `user_agent_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_agent` varchar(255) NOT NULL,
  `ip_address` varchar(255) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `subject_type` varchar(255) NOT NULL,
  `submitted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_user_agent_details_on_subject_id_and_subject_type` (`subject_id`,`subject_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `user_callouts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `feature_name` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_user_callouts_on_user_id_and_feature_name` (`user_id`,`feature_name`),
  KEY `index_user_callouts_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `user_custom_attributes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `user_id` int(11) NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_user_custom_attributes_on_user_id_and_key` (`user_id`,`key`) USING BTREE,
  KEY `index_user_custom_attributes_on_key_and_value` (`key`,`value`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `user_synced_attributes_metadata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name_synced` tinyint(1) DEFAULT '0',
  `email_synced` tinyint(1) DEFAULT '0',
  `location_synced` tinyint(1) DEFAULT '0',
  `user_id` int(11) NOT NULL,
  `provider` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_user_synced_attributes_metadata_on_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `web_hooks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(2000) DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `type` varchar(255) DEFAULT 'ProjectHook',
  `service_id` int(11) DEFAULT NULL,
  `push_events` tinyint(1) NOT NULL DEFAULT '1',
  `issues_events` tinyint(1) NOT NULL DEFAULT '0',
  `merge_requests_events` tinyint(1) NOT NULL DEFAULT '0',
  `tag_push_events` tinyint(1) DEFAULT '0',
  `note_events` tinyint(1) NOT NULL DEFAULT '0',
  `enable_ssl_verification` tinyint(1) DEFAULT '1',
  `wiki_page_events` tinyint(1) NOT NULL DEFAULT '0',
  `token` varchar(255) DEFAULT NULL,
  `pipeline_events` tinyint(1) NOT NULL DEFAULT '0',
  `confidential_issues_events` tinyint(1) NOT NULL DEFAULT '0',
  `repository_update_events` tinyint(1) NOT NULL DEFAULT '0',
  `job_events` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_web_hooks_on_project_id` (`project_id`) USING BTREE,
  KEY `index_web_hooks_on_type` (`type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `web_hook_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `web_hook_id` int(11) NOT NULL,
  `trigger` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `request_headers` longtext,
  `request_data` longtext,
  `response_headers` longtext,
  `response_body` longtext,
  `response_status` varchar(255) DEFAULT NULL,
  `execution_duration` float DEFAULT NULL,
  `internal_error_message` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_web_hook_logs_on_web_hook_id` (`web_hook_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


ALTER TABLE `boards`
  ADD CONSTRAINT `fk_f15266b5f9` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `chat_teams`
  ADD CONSTRAINT `fk_rails_3b543909cb` FOREIGN KEY (`namespace_id`) REFERENCES `namespaces` (`id`) ON DELETE CASCADE;

ALTER TABLE `ci_builds`
  ADD CONSTRAINT `fk_3a9eaa254d` FOREIGN KEY (`stage_id`) REFERENCES `ci_stages` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_a2141b1522` FOREIGN KEY (`auto_canceled_by_id`) REFERENCES `ci_pipelines` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_befce0568a` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `ci_build_trace_sections`
  ADD CONSTRAINT `fk_264e112c66` FOREIGN KEY (`section_name_id`) REFERENCES `ci_build_trace_section_names` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_4ebe41f502` FOREIGN KEY (`build_id`) REFERENCES `ci_builds` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rails_ab7c104e26` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `ci_build_trace_section_names`
  ADD CONSTRAINT `fk_rails_f8cd72cd26` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `ci_group_variables`
  ADD CONSTRAINT `fk_33ae4d58d8` FOREIGN KEY (`group_id`) REFERENCES `namespaces` (`id`) ON DELETE CASCADE;

ALTER TABLE `ci_job_artifacts`
  ADD CONSTRAINT `fk_rails_9862d392f9` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rails_c5137cb2c1` FOREIGN KEY (`job_id`) REFERENCES `ci_builds` (`id`) ON DELETE CASCADE;

ALTER TABLE `ci_pipelines`
  ADD CONSTRAINT `fk_262d4c2d19` FOREIGN KEY (`auto_canceled_by_id`) REFERENCES `ci_pipelines` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_3d34ab2e06` FOREIGN KEY (`pipeline_schedule_id`) REFERENCES `ci_pipeline_schedules` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_86635dbd80` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `ci_pipeline_schedules`
  ADD CONSTRAINT `fk_8ead60fcc4` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_9ea99f58d2` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

ALTER TABLE `ci_pipeline_schedule_variables`
  ADD CONSTRAINT `fk_41c35fda51` FOREIGN KEY (`pipeline_schedule_id`) REFERENCES `ci_pipeline_schedules` (`id`) ON DELETE CASCADE;

ALTER TABLE `ci_pipeline_variables`
  ADD CONSTRAINT `fk_f29c5f4380` FOREIGN KEY (`pipeline_id`) REFERENCES `ci_pipelines` (`id`) ON DELETE CASCADE;

ALTER TABLE `ci_runner_projects`
  ADD CONSTRAINT `fk_4478a6f1e4` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `ci_stages`
  ADD CONSTRAINT `fk_2360681d1d` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_fb57e6cc56` FOREIGN KEY (`pipeline_id`) REFERENCES `ci_pipelines` (`id`) ON DELETE CASCADE;

ALTER TABLE `ci_triggers`
  ADD CONSTRAINT `fk_e3e63f966e` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_e8e10d1964` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

ALTER TABLE `ci_trigger_requests`
  ADD CONSTRAINT `fk_b8ec8b7245` FOREIGN KEY (`trigger_id`) REFERENCES `ci_triggers` (`id`) ON DELETE CASCADE;

ALTER TABLE `ci_variables`
  ADD CONSTRAINT `fk_ada5eb64b3` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `clusters`
  ADD CONSTRAINT `fk_rails_ac3a663d79` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

ALTER TABLE `clusters_applications_helm`
  ADD CONSTRAINT `fk_rails_3e2b1c06bc` FOREIGN KEY (`cluster_id`) REFERENCES `clusters` (`id`) ON DELETE CASCADE;

ALTER TABLE `clusters_applications_prometheus`
  ADD CONSTRAINT `fk_rails_557e773639` FOREIGN KEY (`cluster_id`) REFERENCES `clusters` (`id`) ON DELETE CASCADE;

ALTER TABLE `cluster_platforms_kubernetes`
  ADD CONSTRAINT `fk_rails_e1e2cf841a` FOREIGN KEY (`cluster_id`) REFERENCES `clusters` (`id`) ON DELETE CASCADE;

ALTER TABLE `cluster_projects`
  ADD CONSTRAINT `fk_rails_8b8c5caf07` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rails_a5a958bca1` FOREIGN KEY (`cluster_id`) REFERENCES `clusters` (`id`) ON DELETE CASCADE;

ALTER TABLE `cluster_providers_gcp`
  ADD CONSTRAINT `fk_rails_5c2c3bc814` FOREIGN KEY (`cluster_id`) REFERENCES `clusters` (`id`) ON DELETE CASCADE;

ALTER TABLE `container_repositories`
  ADD CONSTRAINT `fk_rails_32f7bf5aad` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`);

ALTER TABLE `deployments`
  ADD CONSTRAINT `fk_b9a3851b82` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `deploy_keys_projects`
  ADD CONSTRAINT `fk_58a901ca7e` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `environments`
  ADD CONSTRAINT `fk_d1c8c1da6a` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `events`
  ADD CONSTRAINT `fk_edfd187b6f` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rails_0434b48643` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `forked_project_links`
  ADD CONSTRAINT `fk_434510edb0` FOREIGN KEY (`forked_to_project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `fork_networks`
  ADD CONSTRAINT `fk_e7b436b2b5` FOREIGN KEY (`root_project_id`) REFERENCES `projects` (`id`) ON DELETE SET NULL;

ALTER TABLE `fork_network_members`
  ADD CONSTRAINT `fk_b01280dae4` FOREIGN KEY (`forked_from_project_id`) REFERENCES `projects` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_rails_a40860a1ca` FOREIGN KEY (`fork_network_id`) REFERENCES `fork_networks` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rails_efccadc4ec` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `gcp_clusters`
  ADD CONSTRAINT `fk_rails_41d556eb65` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_rails_b1dbe50e98` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rails_dc6f095aad` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

ALTER TABLE `gpg_keys`
  ADD CONSTRAINT `fk_rails_9d1f5d8719` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

ALTER TABLE `gpg_key_subkeys`
  ADD CONSTRAINT `fk_rails_8b2c90b046` FOREIGN KEY (`gpg_key_id`) REFERENCES `gpg_keys` (`id`) ON DELETE CASCADE;

ALTER TABLE `gpg_signatures`
  ADD CONSTRAINT `fk_rails_11ae8cb9a7` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rails_19d4f1c6f9` FOREIGN KEY (`gpg_key_subkey_id`) REFERENCES `gpg_key_subkeys` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_rails_c97176f5f7` FOREIGN KEY (`gpg_key_id`) REFERENCES `gpg_keys` (`id`) ON DELETE SET NULL;

ALTER TABLE `group_custom_attributes`
  ADD CONSTRAINT `fk_rails_246e0db83a` FOREIGN KEY (`group_id`) REFERENCES `namespaces` (`id`) ON DELETE CASCADE;

ALTER TABLE `issues`
  ADD CONSTRAINT `fk_05f1e72feb` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_899c8f3231` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rails_96b1dd429c` FOREIGN KEY (`milestone_id`) REFERENCES `milestones` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_rails_a194299be1` FOREIGN KEY (`moved_to_id`) REFERENCES `issues` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_rails_ffed080f01` FOREIGN KEY (`updated_by_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

ALTER TABLE `issue_assignees`
  ADD CONSTRAINT `fk_5e0c8d9154` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_b7d881734a` FOREIGN KEY (`issue_id`) REFERENCES `issues` (`id`) ON DELETE CASCADE;

ALTER TABLE `issue_metrics`
  ADD CONSTRAINT `fk_rails_4bb543d85d` FOREIGN KEY (`issue_id`) REFERENCES `issues` (`id`) ON DELETE CASCADE;

ALTER TABLE `labels`
  ADD CONSTRAINT `fk_7de4989a69` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rails_c1ac5161d8` FOREIGN KEY (`group_id`) REFERENCES `namespaces` (`id`) ON DELETE CASCADE;

ALTER TABLE `label_priorities`
  ADD CONSTRAINT `fk_rails_e161058b0f` FOREIGN KEY (`label_id`) REFERENCES `labels` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rails_ef916d14fa` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `lfs_file_locks`
  ADD CONSTRAINT `fk_rails_27a1d98fa8` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rails_43df7a0412` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `lists`
  ADD CONSTRAINT `fk_0d3f677137` FOREIGN KEY (`board_id`) REFERENCES `boards` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_7a5553d60f` FOREIGN KEY (`label_id`) REFERENCES `labels` (`id`) ON DELETE CASCADE;

ALTER TABLE `members`
  ADD CONSTRAINT `fk_rails_2e88fb7ce9` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

ALTER TABLE `merge_requests`
  ADD CONSTRAINT `fk_06067f5644` FOREIGN KEY (`latest_merge_request_diff_id`) REFERENCES `merge_request_diffs` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_a6963e8447` FOREIGN KEY (`target_project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_fd82eae0b9` FOREIGN KEY (`head_pipeline_id`) REFERENCES `ci_pipelines` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_rails_3308fe130c` FOREIGN KEY (`source_project_id`) REFERENCES `projects` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_rails_6149611a04` FOREIGN KEY (`assignee_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_rails_641731faff` FOREIGN KEY (`updated_by_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_rails_6a5165a692` FOREIGN KEY (`milestone_id`) REFERENCES `milestones` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_rails_ad525e1f87` FOREIGN KEY (`merge_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_rails_e719a85f8a` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

ALTER TABLE `merge_requests_closing_issues`
  ADD CONSTRAINT `fk_rails_458eda8667` FOREIGN KEY (`merge_request_id`) REFERENCES `merge_requests` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rails_f8540692be` FOREIGN KEY (`issue_id`) REFERENCES `issues` (`id`) ON DELETE CASCADE;

ALTER TABLE `merge_request_diffs`
  ADD CONSTRAINT `fk_8483f3258f` FOREIGN KEY (`merge_request_id`) REFERENCES `merge_requests` (`id`) ON DELETE CASCADE;

ALTER TABLE `merge_request_diff_commits`
  ADD CONSTRAINT `fk_rails_316aaceda3` FOREIGN KEY (`merge_request_diff_id`) REFERENCES `merge_request_diffs` (`id`) ON DELETE CASCADE;

ALTER TABLE `merge_request_diff_files`
  ADD CONSTRAINT `fk_rails_501aa0a391` FOREIGN KEY (`merge_request_diff_id`) REFERENCES `merge_request_diffs` (`id`) ON DELETE CASCADE;

ALTER TABLE `merge_request_metrics`
  ADD CONSTRAINT `fk_rails_33ae169d48` FOREIGN KEY (`pipeline_id`) REFERENCES `ci_pipelines` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rails_7f28d925f3` FOREIGN KEY (`merged_by_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_rails_ae440388cc` FOREIGN KEY (`latest_closed_by_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_rails_e6d7c24d1b` FOREIGN KEY (`merge_request_id`) REFERENCES `merge_requests` (`id`) ON DELETE CASCADE;

ALTER TABLE `milestones`
  ADD CONSTRAINT `fk_95650a40d4` FOREIGN KEY (`group_id`) REFERENCES `namespaces` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_9bd0a0c791` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `notes`
  ADD CONSTRAINT `fk_99e097b079` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `oauth_openid_requests`
  ADD CONSTRAINT `fk_oauth_openid_requests_oauth_access_grants_access_grant_id` FOREIGN KEY (`access_grant_id`) REFERENCES `oauth_access_grants` (`id`);

ALTER TABLE `pages_domains`
  ADD CONSTRAINT `fk_ea2f6dfc6f` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `personal_access_tokens`
  ADD CONSTRAINT `fk_rails_08903b8f38` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `project_authorizations`
  ADD CONSTRAINT `fk_rails_0f84bb11f3` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rails_11e7aa3ed9` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

ALTER TABLE `project_auto_devops`
  ADD CONSTRAINT `fk_rails_45436b12b2` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `project_custom_attributes`
  ADD CONSTRAINT `fk_rails_719c3dccc5` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `project_features`
  ADD CONSTRAINT `fk_18513d9b92` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `project_group_links`
  ADD CONSTRAINT `fk_daa8cee94c` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `project_import_data`
  ADD CONSTRAINT `fk_ffb9ee3a10` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `project_statistics`
  ADD CONSTRAINT `fk_rails_12c471002f` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `protected_branches`
  ADD CONSTRAINT `fk_7a9c6d93e7` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `protected_branch_merge_access_levels`
  ADD CONSTRAINT `fk_8a3072ccb3` FOREIGN KEY (`protected_branch_id`) REFERENCES `protected_branches` (`id`) ON DELETE CASCADE;

ALTER TABLE `protected_branch_push_access_levels`
  ADD CONSTRAINT `fk_9ffc86a3d9` FOREIGN KEY (`protected_branch_id`) REFERENCES `protected_branches` (`id`) ON DELETE CASCADE;

ALTER TABLE `protected_tags`
  ADD CONSTRAINT `fk_8e4af87648` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `protected_tag_create_access_levels`
  ADD CONSTRAINT `fk_f7dfda8c51` FOREIGN KEY (`protected_tag_id`) REFERENCES `protected_tags` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rails_2349b78b91` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `fk_rails_b4eb82fe3c` FOREIGN KEY (`group_id`) REFERENCES `namespaces` (`id`);

ALTER TABLE `push_event_payloads`
  ADD CONSTRAINT `fk_36c74129da` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE;

ALTER TABLE `releases`
  ADD CONSTRAINT `fk_47fe2a0596` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `services`
  ADD CONSTRAINT `fk_71cce407f9` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `snippets`
  ADD CONSTRAINT `fk_be41fd4bb7` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `subscriptions`
  ADD CONSTRAINT `fk_rails_d0c8bda804` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `system_note_metadata`
  ADD CONSTRAINT `fk_d83a918cb1` FOREIGN KEY (`note_id`) REFERENCES `notes` (`id`) ON DELETE CASCADE;

ALTER TABLE `timelogs`
  ADD CONSTRAINT `fk_timelogs_issues_issue_id` FOREIGN KEY (`issue_id`) REFERENCES `issues` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_timelogs_merge_requests_merge_request_id` FOREIGN KEY (`merge_request_id`) REFERENCES `merge_requests` (`id`) ON DELETE CASCADE;

ALTER TABLE `todos`
  ADD CONSTRAINT `fk_45054f9c45` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rails_91d1f47b13` FOREIGN KEY (`note_id`) REFERENCES `notes` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rails_ccf0373936` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rails_d94154aa95` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

ALTER TABLE `trending_projects`
  ADD CONSTRAINT `fk_rails_09feecd872` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `u2f_registrations`
  ADD CONSTRAINT `fk_rails_bfe6a84544` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `users_star_projects`
  ADD CONSTRAINT `fk_22cd27ddfc` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `user_callouts`
  ADD CONSTRAINT `fk_rails_ddfdd80f3d` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

ALTER TABLE `user_custom_attributes`
  ADD CONSTRAINT `fk_rails_47b91868a8` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

ALTER TABLE `user_synced_attributes_metadata`
  ADD CONSTRAINT `fk_rails_0f4aa0981f` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

ALTER TABLE `web_hooks`
  ADD CONSTRAINT `fk_0c8ca6d9d1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

ALTER TABLE `web_hook_logs`
  ADD CONSTRAINT `fk_rails_666826e111` FOREIGN KEY (`web_hook_id`) REFERENCES `web_hooks` (`id`) ON DELETE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
