<?php
// Jenkins service definition
return array(
	'weight'		=> 30,
	'id'			=> 'jenkins',
	'url'			=> '/jenkins/',
	'title'			=> 'Jenkins',
	'description'	=> 'Int&eacute;gration continue',
	'details'		=> <<<EOL
        <ul>
          <li><strong>Intégration continue</strong> des développements et tests unitaires</li>
          <li>Génération de <strong>rapports de tests</strong></li>
          <li>Suivi de l'évolution des tests au fil du temps et <strong>notification</strong> des développeurs en cas d'échec ou de régression</li>
          <li><em>Plus d'informations : <a href="http://www.jenkins-ci.org">site officiel de Jenkins</a></em></li>
        </ul>
EOL

);
