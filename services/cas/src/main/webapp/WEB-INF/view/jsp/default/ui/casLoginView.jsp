<jsp:directive.include file="includes/top.jsp" />

<c:if test="${not pageContext.request.secure}">
<div id="msg" class="alert alert-danger">
	<h2><spring:message code="screen.nonsecure.title" /></h2>
	<p><spring:message code="screen.nonsecure.message" /></p>
</div>
</c:if>

<div id="login">
	<form:form method="post" id="fm1" cssClass="form-horizontal" commandName="${commandName}" htmlEscape="true">
		<h2><spring:message code="screen.welcome.instructions" /></h2>
		<div id="instructions"><spring:message code="screen.welcome.instructions.details" /></div>
		<form:errors path="*" id="msg" cssClass="alert alert-danger" element="div" htmlEscape="false" />
		<div class="form-group form-group-sm">
			<label for="username" class="col-sm-4 control-label"><spring:message code="screen.welcome.label.netid" /></label>
			<div class="col-sm-7">
				<c:choose>
					<c:when test="${not empty sessionScope.openIdLocalId}">
						<p class="form-control-static"><c:out value="${sessionScope.openIdLocalId}" /></p>
						<input type="hidden" id="username" name="username" value="<c:out value="${sessionScope.openIdLocalId}" />" />
					</c:when>
					<c:otherwise>
						<spring:message code="screen.welcome.label.netid.accesskey" var="userNameAccessKey" />
						<form:input cssClass="form-control" id="username" size="25" tabindex="1" accesskey="${userNameAccessKey}" path="username" htmlEscape="true" />
					</c:otherwise>
				</c:choose>
			</div>
		</div>
		<div class="form-group form-group-sm">
			<label for="password" class="col-sm-4 control-label"><spring:message code="screen.welcome.label.password" /></label>
			<div class="col-sm-7">
				<spring:message code="screen.welcome.label.password.accesskey" var="passwordAccessKey" />
				<form:password cssClass="form-control" id="password" size="25" tabindex="2" accesskey="${passwordAccessKey}" path="password" htmlEscape="true" />
			</div>
		</div>
		<div class="form-group form-group-sm">
			<div class="col-sm-offset-4 col-sm-7">
				<div class="checkbox">
					<label>
						<input type="checkbox" name="rememberMe" id="rememberMe" value="true" tabindex="3" />
						<spring:message code="screen.rememberme.checkbox.title" />
					</label>
				</div>
			</div>
		</div>
		<div class="form-group form-group-sm">
			<div class="col-sm-offset-4 col-sm-7">
				<input type="hidden" name="lt" value="${loginTicket}" />
				<input type="hidden" name="execution" value="${flowExecutionKey}" />
				<input type="hidden" name="_eventId" value="submit" />
				<input class="btn btn-primary" name="submit" accesskey="l" value="<spring:message code="screen.welcome.button.login" />" tabindex="4" type="submit" />
			</div>
		</div>
	</form:form>
</div>

<jsp:directive.include file="includes/bottom.jsp" />