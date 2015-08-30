<%--

    Licensed to Jasig under one or more contributor license
    agreements. See the NOTICE file distributed with this work
    for additional information regarding copyright ownership.
    Jasig licenses this file to you under the Apache License,
    Version 2.0 (the "License"); you may not use this file
    except in compliance with the License.  You may obtain a
    copy of the License at the following location:

      http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.

--%>
<jsp:directive.include file="includes/top.jsp" />

<c:if test="${not pageContext.request.secure}">
<div id="msg" class="alert alert-danger">
	<h2>Non-secure Connection</h2>
	<p>You are currently accessing CAS over a non-secure connection.  Single Sign On WILL NOT WORK.  In order to have single sign on work, you MUST log in over HTTPS.</p>
</div>
</c:if>

<div id="login">
	<form:form method="post" id="fm1" cssClass="form-horizontal" commandName="${commandName}" htmlEscape="true">
		<h2><spring:message code="screen.welcome.instructions" /></h2>
		<div id="instructions"><spring:message code="screen.welcome.instructions.details" /></div>
		<form:errors path="*" id="msg" cssClass="alert alert-danger" element="div" />
		<div class="form-group form-group-sm">
			<label for="username" class="col-sm-4 control-label"><spring:message code="screen.welcome.label.netid" /></label>
			<div class="col-sm-7">
				<c:if test="${not empty sessionScope.openIdLocalId}">
					<p class="form-control-static">${sessionScope.openIdLocalId}</p>
					<input type="hidden" id="username" name="username" value="${sessionScope.openIdLocalId}" />
				</c:if>
				<c:if test="${empty sessionScope.openIdLocalId}">
					<spring:message code="screen.welcome.label.netid.accesskey" var="userNameAccessKey" />
					<form:input cssClass="form-control" id="username" size="25" tabindex="1" accesskey="${userNameAccessKey}" path="username" htmlEscape="true" />
				</c:if>
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
						<input type="checkbox" name="rememberMe" id="rememberMe" value="true" tabindex="3" accesskey="<spring:message code="screen.welcome.label.rememberme.accesskey" />" />
						<spring:message code="screen.welcome.label.rememberme" />
					</label>
				</div>
			</div>
		</div>
		<!--
		<div class="form-group form-group-sm">
			<div class="col-sm-offset-4 col-sm-7">
				<div class="checkbox">
					<label>
						<input type="checkbox" id="warn" name="warn" value="true" tabindex="3" accesskey="<spring:message code="screen.welcome.label.warn.accesskey" />" />
						<spring:message code="screen.welcome.label.warn" />
					</label>
				</div>
			</div>
		</div>
		-->
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