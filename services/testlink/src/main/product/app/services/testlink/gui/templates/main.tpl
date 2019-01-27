{* Testlink Open Source Project - http://testlink.sourceforge.net/ *}
{* @filesource main.tpl *}
{* Purpose: smarty template - main frame *}
{*******************************************************************}
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en" style="height: 100%">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset={$pageCharset}" />
	<meta http-equiv="Content-language" content="en" />
	<meta name="generator" content="testlink" />
	<meta name="author" content="TestLink Development Team" />
	<meta name="copyright" content="TestLink Development Team" />
	<meta name="robots" content="NOFOLLOW" />
	<title>TestLink {$tlVersion|escape}</title>
	<meta name="description" content="TestLink - {$gui->title|default:"Main page"}" />
	<link rel="icon" href="{$basehref}{$smarty.const.TL_THEME_IMG_DIR}favicon.ico" type="image/x-icon" />
	<style media="all" type="text/css">@import "{$css}";</style>
	{if $use_custom_css}
	<style media="all" type="text/css">@import "{$custom_css}";</style>
	{/if}
	<script type="text/javascript" src="/portal/toolbar.php?tab=testlink&amp;format=js"></script>
</head>

<body id="main-body">
<div id="main-wrapper">
  <div id="main-header">
    <iframe id="titlebar" src="{$gui->titleframe}" name="titlebar" scrolling="no" frameborder="0" width="100%" height="70"></iframe>
  </div>
  <div id="main-content">
    <iframe id="mainframe" src="{$gui->mainframe}" name="mainframe" scrolling="auto" frameborder="0" width="100%" height="100%"></iframe>
  </div>
</div>
</body>

</html>
