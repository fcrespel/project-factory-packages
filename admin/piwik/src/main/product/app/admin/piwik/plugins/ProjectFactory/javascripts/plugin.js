$(document).ready(function () {
	var toolbarScript = document.createElement('script');
	toolbarScript.type = 'text/javascript';
	toolbarScript.src = '/portal/toolbar.php?tab=piwik&format=js';
	document.getElementsByTagName("head")[0].appendChild(toolbarScript);
});
