<?php
// SVN service definition
return array(
	'weight'		=> 20,
	'id'			=> 'svn',
	'url'			=> '/svn/',
	'title'			=> 'Subversion',
	'description'	=> 'D&eacute;p&ocirc;ts de sources SVN',
	'details'		=> <<<EOL
        <ul>
          <li><strong>Dépôts de sources SVN</strong> (développements, cas de test, ...)</li>
          <li>Journalisation centralisée des changements</li>
          <li>Déclenchement d'un build Jenkins lors d'un <em>commit</em></li>
          <li><em>Plus d'informations : <a href="http://subversion.apache.org">site officiel de SVN</a> - <a href="http://svnbook.red-bean.com/en/1.5/svn-book.html">SVN Book</a></em></li>
        </ul>
EOL

);
