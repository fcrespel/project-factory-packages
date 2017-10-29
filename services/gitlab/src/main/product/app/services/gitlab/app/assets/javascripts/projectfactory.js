(function() {
	var toolbarScript = document.createElement('script');
	toolbarScript.type = 'text/javascript';
	toolbarScript.src = '/portal/toolbar.php?tab=gitlab&format=js';
	document.getElementsByTagName("head")[0].appendChild(toolbarScript);
	$(document).ready(function() {
		if (typeof add_platform_toolbar === 'function') {
			add_platform_toolbar();
		}
	});
}).call(window);
