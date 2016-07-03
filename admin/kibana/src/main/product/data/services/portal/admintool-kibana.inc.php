<?php
// Kibana admin tool definition
return array(
	'weight'		=> 50,
	'id'			=> 'kibana',
	'url'			=> '/admin/kibana/',
	'title'			=> 'Kibana',
	'description'	=> 'Visualisation de donn&eacute;es Elasticsearch',
	'details'		=> <<<EOL
        <ul>
          <li>Visualisation des <strong>données issues d'Elasticsearch</strong> sous forme de tableau de bord</li>
          <li><em>Plus d'informations : <a href="https://www.elastic.co/products/kibana">site officiel</a></em></li>
        </ul>
EOL

);
