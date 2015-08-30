<?php
// Data directory for custom config and service/admin tool descriptors
$dataDir = '@{package.data}';

// Initialize config array
$config = array(

    // Platform title (displayed e.g. in the toolbar)
    'title' => 'Project Factory',

    // Platform logos
    'logo' => null,
    'logo_toolbar' => null,

    // Services definitions
    'services' => array(),

    // Admin tools definitions
    'admintools' => array(),

    // Service announcements
    'serviceMessage' => array(
        'enabled'    => false,
        'type'       => 'info', // info, warning, critical
        'title'      => '',
        'detail'     => '',
    ),
    
    // Contacts
    'contacts' => array(),

);

// Merge local configuration
if (file_exists($dataDir . '/config.inc.php')) {
    $config_local = include($dataDir . '/config.inc.php');
    if (is_array($config_local)) {
        $config = array_merge($config, $config_local);
    }
}

// Merge services defined externally
$serviceFiles = glob($dataDir . '/service-*.inc.php');
if ($serviceFiles !== false && is_array($serviceFiles)) {
    foreach ($serviceFiles as $serviceFile) {
        $service = include($serviceFile);
        if (is_array($service) && isset($service['id'])) {
            $config['services'][$service['id']] = $service;
        }
    }
	uasort($config['services'], function($s1, $s2) { return $s1['weight'] - $s2['weight']; });
}

// Merge admin tools defined externally
$admintoolFiles = glob($dataDir . '/admintool-*.inc.php');
if ($admintoolFiles !== false && is_array($admintoolFiles)) {
    foreach ($admintoolFiles as $admintoolFile) {
        $admintool = include($admintoolFile);
        if (is_array($admintool) && isset($admintool['id'])) {
            $config['admintools'][$admintool['id']] = $admintool;
        }
    }
	uasort($config['admintools'], function($s1, $s2) { return $s1['weight'] - $s2['weight']; });
}

// Define output format
$config['format'] = 'html';
if (isset($_GET['format'])) {
	switch ($_GET['format']) {
		case 'js':
		case 'javascript':
			$config['format'] = 'javascript';
			break;
		case 'json':
		case 'ajax':
			$config['format'] = 'json';
			break;
	}
}

// Export config in globals
$GLOBALS['portal-config'] = $config;
