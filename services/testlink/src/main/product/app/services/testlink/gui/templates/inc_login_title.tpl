{* 
TestLink Open Source Project - http://testlink.sourceforge.net/ 
@filesoruce inc_login_title.tpl
Purpose: smarty template - login page title
*}
<script type="text/javascript" src="/portal/toolbar.php?tab=testlink&amp;format=js"></script>
<div class="login_title">
<p><img alt="Company logo" title="logo" src="{$smarty.const.TL_THEME_IMG_DIR}{$tlCfg->logo_login}" />
   <br />TestLink {$tlVersion|escape}</p>
</div>