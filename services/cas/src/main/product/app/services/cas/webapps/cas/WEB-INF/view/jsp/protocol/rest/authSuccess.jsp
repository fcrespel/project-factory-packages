<%@ page session="false" pageEncoding="UTF-8" contentType="application/xml; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<cas:serviceResponse xmlns:cas='http://www.yale.edu/tp/cas'>
	<cas:authenticationSuccess>
		<cas:user>${fn:escapeXml(auth.principal.id)}</cas:user>
		<cas:attributes>
<c:forEach var="attr" items="${auth.principal.attributes}" >
			<cas:${fn:escapeXml(attr.key)}>${fn:escapeXml(attr.value)}</cas:${fn:escapeXml(attr.key)}>
</c:forEach>
		</cas:attributes>
	</cas:authenticationSuccess>
</cas:serviceResponse>