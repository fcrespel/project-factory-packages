<jsp:directive.include file="includes/top.jsp" />

<div id="msg" class="alert alert-warning">
	<h2>Authentication Succeeded with Warnings</h2>

	<c:forEach items="${messages}" var="message">
	<p>${message.text}</p>
	</c:forEach>
</div>

<c:url value="login" var="url">
	<c:param name="execution" value="${flowExecutionKey}" />
	<c:param name="_eventId" value="proceed" />
</c:url>

<p><a class="btn btn-primary" href="${url}">Continue</a></p>

<jsp:directive.include file="includes/bottom.jsp" />
