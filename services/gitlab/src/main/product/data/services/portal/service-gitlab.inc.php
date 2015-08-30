<?php
// GitLab service definition
return array(
	'weight'		=> 25,
	'id'			=> 'gitlab',
	'url'			=> '/gitlab/',
	'title'			=> 'GitLab',
	'description'	=> 'D&eacute;p&ocirc;ts de sources Git',
	'details'		=> <<<EOL
        <ul>
          <li><strong>Dépôts de sources Git</strong> (développements, cas de test, ...)</li>
          <li>Journalisation décentralisée des changements, collaboration, &laquo; forks &raquo; et &laquo; merge requests &raquo;</li>
          <li>Déclenchement d'un build Jenkins lors d'un <em>push</em></li>
          <li><em>Plus d'informations : <a href="https://about.gitlab.com/gitlab-ce/">site officiel de GitLab</a></em></li>
        </ul>
EOL

);
