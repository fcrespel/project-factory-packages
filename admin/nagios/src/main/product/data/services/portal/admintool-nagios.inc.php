<?php
// Nagios admin tool definition
return array(
	'weight'		=> 30,
	'id'			=> 'nagios',
	'url'			=> '/admin/nagios/wrapper.html',
	'title'			=> 'Nagios',
	'description'	=> 'Monitoring des services et alertes',
	'details'		=> <<<EOL
        <ul>
          <li><strong>Monitoring</strong> des services de la plateforme</li>
          <li><em>Plus d'informations : <a href="http://www.nagios.org">site officiel</a></em></li>
        </ul>
EOL

);
