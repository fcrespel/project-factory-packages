<?php
// phpLDAPadmin admin tool definition
return array(
	'weight'		=> 20,
	'id'			=> 'phpldapadmin',
	'url'			=> '/admin/phpldapadmin/wrapper.html',
	'title'			=> 'phpLDAPadmin',
	'description'	=> "Administration de l'annuaire d'utilisateurs LDAP",
	'details'		=> <<<EOL
        <ul>
          <li>Administration du serveur <strong>LDAP</strong> (annuaire d'utilisateurs)</li>
          <li>Consultation et création d'<strong>utilisateurs</strong> pour les différents services (Redmine, Jenkins, SVN)</li>
          <li><em>Plus d'informations : <a href="http://phpldapadmin.sourceforge.net">site officiel</a></em></li>
        </ul>
EOL

);
