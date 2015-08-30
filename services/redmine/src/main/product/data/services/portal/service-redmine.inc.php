<?php
// Redmine service definition
return array(
	'weight'		=> 10,
	'id'			=> 'redmine',
	'url'			=> '/redmine/',
	'title'			=> 'Redmine',
	'description'	=> 'Gestion de projet, suivi des demandes, wiki...',
	'details'		=> <<<EOL
        <ul>
          <li>Outil de <strong>gestion de projet</strong></li>
          <li>Saisie et suivi de <strong>demandes</strong> (évolutions, anomalies, support), <strong>calendrier</strong> et diagrammes de Gantt</li>
          <li><strong>Wiki intégré</strong>, hébergement de <strong>fichiers et documents</strong>, consultation de dépôt de sources</li>
          <li><em>Plus d'informations : <a href="http://www.redmine.org">site officiel de Redmine</a> - <a href="http://www.redmine.org/wiki/redmine/Guide">Redmine Guide</a></em></li>
        </ul>
EOL

);
