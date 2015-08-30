<?php
// Nexus service definition
return array(
	'weight'		=> 40,
	'id'			=> 'nexus',
	'url'			=> '/nexus/wrapper.html',
	'title'			=> 'Nexus',
	'description'	=> 'D&eacute;p&ocirc;ts de logiciels (Repository Manager)',
	'details'		=> <<<EOL
        <ul>
          <li><strong>Gestionnaire de dépôts de logiciels</strong> (Repository Manager)</li>
          <li>Déploiement, archivage, mise à disposition d'<em>artifacts</em> Maven, NPM, RubyGems, etc. (binaires et sources)</li>
          <li>Référentiel d'<em>archetypes</em> (<strong>modèles de projets</strong>) Maven réutilisables</li>
          <li><em>Plus d'informations : <a href="http://nexus.sonatype.org">site officiel de Nexus</a></em></li>
        </ul>
EOL

);
