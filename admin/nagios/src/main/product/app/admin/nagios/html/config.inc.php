<?php
//


$cfg['cgi_config_file']='@{package.app}/conf/cgi.cfg';  // location of the CGI config file

$cfg['cgi_base_url']='/admin/nagios/cgi-bin';


// FILE LOCATION DEFAULTS
$cfg['main_config_file']='@{package.app}/conf/nagios.cfg';  // default location of the main Nagios config file
$cfg['status_file']='@{package.data}/var/status.dat'; // default location of Nagios status file
$cfg['state_retention_file']='@{package.data}/var/retention.dat'; // default location of Nagios retention file



// utilities
require_once(dirname(__FILE__).'/includes/utils.inc.php');

?>
