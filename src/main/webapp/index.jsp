<%@page import="java.util.Map"%>
<%@page import="edw.olingo.service.ServiceInformation"%>
<%@ taglib prefix="f" uri="/WEB-INF/functions.tld"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	Map<String, Object> update = ServiceInformation
			.checkProductUpdates();
	pageContext.setAttribute("updateRequired",
			(Boolean) update.get("needsUpdate"));
	pageContext.setAttribute("updateCheckSuccessful",
			(Boolean) update.get("success"));
	pageContext.setAttribute("remoteVersion",
			update.get("remoteVersion"));

	pageContext.setAttribute("countMeetings",
			ServiceInformation.countMeetings());
	pageContext.setAttribute("countDecisions",
			ServiceInformation.countDecisions());
	pageContext.setAttribute("countContacts",
			ServiceInformation.countContacts());
	pageContext.setAttribute("countCountryReports",
			ServiceInformation.countCountryReports());
	pageContext.setAttribute("countNationalPlans",
			ServiceInformation.countNationalPlans());
	pageContext.setAttribute("countSites",
			ServiceInformation.countSites());
	pageContext.setAttribute("countTreaties",
			ServiceInformation.countTreaties());
	pageContext.setAttribute("countDocuments",
			ServiceInformation.countDocuments());
%>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css">
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
</head>
<body>
	<nav class="navbar navbar-default navbar-static-top" role="navigation">
		<div class="container">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle collapsed"
					data-toggle="collapse" data-target="#navbar" aria-expanded="false"
					aria-controls="navbar">
					<span class="sr-only">Toggle navigation</span> <span
						class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="http://www.informea.org"
					target="_blank">InforMEA OData provider</a>
			</div>
			<div id="navbar" class="navbar-collapse collapse">
				<ul class="nav navbar-nav navbar-right">
					<li><p class="navbar-text">
							<c:choose>
								<c:when test="${not updateCheckSuccessful}">
									<span class="label label-danger">running v.
										${f:getVersion()}, cannot check for updates</span>
								</c:when>
								<c:when test="${updateCheckSuccessful}">
									<c:if test="${updateRequired}">
										<span class="label label-warning">running v.
											${f:getVersion()}, new version ${remoteVersion} available</span>
									</c:if>
									<c:if test="${not updateRequired}">
										<span class="label label-success">running v.
											${f:getVersion()} latest</span>
									</c:if>
								</c:when>
							</c:choose>
							<a href="http://github.com/informea/odata.provider/releases" target="_blank">view</a>
						</p></li>
				</ul>
			</div>
			<!--/.nav-collapse -->
		</div>
	</nav>
	<div class="container">
		<div class="jumbotron">
			<h1>InforMEA OData toolkit</h1>
			<p>Exposes the existing database entities as OData web service
				endpoint.</p>
		</div>
		<div class="page-header">
			<h2>Status</h2>
		</div>
		<dl class="dl-horizontal">
			<dt>Service endpoint</dt>
			<dd>
				<a href="informea.svc" target="_blank">View</a>
			</dd>
			<dt>Service metadata</dt>
			<dd>
				<a href="informea.svc/$metadata" target="_blank">View</a>
			</dd>
		</dl>
		<table class="table table-striped table-condensed">
			<caption>Current status of the web service</caption>
			<thead>
				<tr>
					<th>Entity</th>
					<th class="text-nowrap">Item count</th>
					<th>Data</th>
					<th class="hidden-xs">Notes</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>Treaties</td>
					<td><c:if test="${countTreaties > 0}">${countTreaties}</c:if>
						<c:if test="${countTreaties == 0}">n/a</c:if></td>
					<td>&nbsp; <c:if test="${countTreaties > 0}">
							<a target="_blank" title="Click to see the entities. Open in new tab" 
								href="informea.svc/Treaties">View all</a></c:if>
					</td>
					<td class="hidden-xs">&nbsp;</td>
				</tr>
				<tr>
					<td>Meetings</td>
					<td><c:if test="${countMeetings > 0}">${countMeetings}</c:if>
						<c:if test="${countMeetings == 0}">n/a</c:if></td>
					<td>&nbsp; <c:if test="${countMeetings > 0}">
							<a target="_blank" title="Click to see the entities. Open in new tab" 
								href="informea.svc/Meetings?$top=5&$skip=0&$expand=description,title&$orderby=updated%20desc">View most recently updated 5</a></c:if>
					</td>
					<td class="hidden-xs">&nbsp;</td>
				</tr>
				<tr>
					<td>Decisions</td>
					<td><c:if test="${countDecisions > 0}">${countDecisions}</c:if> <c:if test="${countDecisions == 0}">n/a</c:if></td>
					<td>&nbsp; <c:if test="${countDecisions > 0}">
							<a target="_blank" title="Click to see the entities. Open in new tab"
								href="informea.svc/Decisions?$top=5&$skip=0&$expand=content,files,keywords,longTitle,summary,title&$orderby=updated%20desc">View most recently updated 5</a>
						</c:if>
					</td>
					<td class="hidden-xs">&nbsp;</td>
				</tr>
				<tr>
					<td>Contacts</td>
					<td><c:if test="${countContacts > 0}">${countContacts}</c:if> <c:if test="${countContacts == 0}">n/a</c:if></td>
					<td>&nbsp; <c:if test="${countContacts > 0}">
							<a target="_blank" title="Click to see the entities. Open in new tab"
								href="informea.svc/Contacts?$top=5&$skip=0&$expand=treaties&$orderby=updated%20desc">View most recently updated 5</a>
						</c:if>
					</td>
					<td class="hidden-xs">&nbsp;</td>
				</tr>
				<tr>
					<td>National reports</td>
					<td><c:if test="${countCountryReports > 0}">${countCountryReports}</c:if> <c:if test="${countCountryReports == 0}">n/a</c:if></td>
					<td>&nbsp; <c:if test="${countCountryReports > 0}">
							<a target="_blank" title="Click to see the entities. Open in new tab"
								href="informea.svc/CountryReports?$top=5&$skip=0&$expand=files,title&$orderby=updated%20desc">View most recently updated 5</a>
						</c:if>
					</td>
					<td class="hidden-xs">&nbsp;</td>
				</tr>
				<tr>
					<td>National action plans</td>
					<td><c:if test="${countNationalPlans > 0}">${countNationalPlans}</c:if> <c:if test="${countNationalPlans == 0}">n/a</c:if></td>
					<td>&nbsp; <c:if test="${countNationalPlans > 0}">
							<a target="_blank" title="Click to see the entities. Open in new tab"
								href="informea.svc/NationalPlans?$top=5&$skip=0&$expand=files,title&$orderby=updated%20desc">View most recently updated 5</a>
						</c:if>
					</td>
					<td class="hidden-xs">&nbsp;</td>
				</tr>
				<tr>
					<td>Sites</td>
					<td><c:if test="${countSites > 0}">${countSites}</c:if><c:if test="${countSites == 0}">n/a</c:if></td>
					<td>&nbsp; <c:if test="${countSites > 0}">
							<a target="_blank" title="Click to see the entities. Open in new tab"
								href="informea.svc/Sites?$top=5&$skip=0&$expand=name&$orderby=updated%20desc">View most recently updated 5</a>
							<br />
						</c:if>
					</td>
					<td class="hidden-xs">
						Applies only to Ramsar &amp; WHC sites
					</td>
				</tr>

				<tr>
					<td>Documents</td>
					<td><c:if test="${countDocuments > 0}">${countDocuments}</c:if> <c:if test="${countDocuments == 0}">n/a</c:if></td>
					<td>&nbsp; <c:if test="${countDocuments > 0}">
						<a target="_blank" title="Click to see the entities. Open in new tab"
						   href="informea.svc/Documents?$top=5&$skip=0&$expand=authors,types,treaties,title,tags,referenceToEntities,keywords,identifiers,files,description&$orderby=updated%20desc">View most recently updated 5</a>
					</c:if>
					</td>
					<td class="hidden-xs">&nbsp;</td>
				</tr>
			</tbody>
		</table>
		<div class="page-header">
			<h2>Documentation</h2>
		</div>
		<p>
			This project is built and supported under the <a target="_blank"
				href="http://www.informea.org/api">InforMEA</a> project. Please
			visit the support page where you can find up to date documentation.
			<br /> OData documentation available at <a href="http://www.odata.org" target="_blank">http://www.odata.org</a>.
		</p>
	</div>
	<!-- /container -->
</body>
</html>
