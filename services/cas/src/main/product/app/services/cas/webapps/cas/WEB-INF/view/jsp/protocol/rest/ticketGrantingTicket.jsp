<%@ page session="false" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>TGT Created</title>
</head>
<body>
<h1>TGT Created</h1>
<form action="${ticket_ref}" method="POST">
Service:<input type="text" name="service" value=""><br />
<input type="submit" value="Submit" />
</form>
</body>
</html>