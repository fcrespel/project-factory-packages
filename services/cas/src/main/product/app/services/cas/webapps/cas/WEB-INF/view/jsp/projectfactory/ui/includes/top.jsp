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
<!DOCTYPE html>
<%@ page session="true" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,IE=11,IE=10,IE=9" />
		<meta charset="UTF-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
		<title>CAS &#8211; Central Authentication Service</title>
		<link type="text/css" rel="stylesheet" href="<c:url value="/themes/projectfactory/lib/bootstrap-3.3.4/css/bootstrap.min.css" />" />
		<spring:theme code="standard.custom.css.file" var="customCssFile" />
		<link type="text/css" rel="stylesheet" href="<c:url value="${customCssFile}" />" />
		<link type="image/x-icon" rel="icon" href="<c:url value="/favicon.ico" />" />
		<script type="text/javascript" src="/portal/toolbar.php?tab=cas&amp;format=js"></script>
	</head>
	<body id="cas">
		<div class="container">
			<div class="row">
				<div class="col-sm-offset-1 col-sm-10 col-md-offset-2 col-md-8">
					<div id="wrapper" class="row">
						<div id="header" class="col-md-12">
							<h1 id="app-name"><spring:message code="screen.title" /></h1>
						</div>		
						<div id="content" class="col-sm-offset-1 col-sm-10 col-md-offset-2 col-md-8">
