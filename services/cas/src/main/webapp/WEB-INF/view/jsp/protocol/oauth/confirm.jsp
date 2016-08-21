<jsp:directive.include file="../../default/ui/includes/top.jsp" />
<div id="msg" class="alert alert-info">
	<h2><spring:message code="screen.oauth.confirm.header" /></h2>
	<p><spring:message code="screen.oauth.confirm.message" arguments="${serviceName}" /></p>
	<p><a id="allow" name="allow" class="btn btn-primary" href="${callbackUrl}"><spring:message code="screen.oauth.confirm.allow" /></a></p>
</div>
<jsp:directive.include file="../../default/ui/includes/bottom.jsp" />
