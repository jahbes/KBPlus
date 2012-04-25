
<%@ page import="com.k_int.kbplus.Org" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="bootstrap">
		<g:set var="entityName" value="${message(code: 'org.label', default: 'Org')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<div class="row-fluid">
			
			<div class="span3">
				<div class="well">
					<ul class="nav nav-list">
						<li class="nav-header">${entityName}</li>
						<li>
							<g:link class="list" action="list">
								<i class="icon-list"></i>
								<g:message code="default.list.label" args="[entityName]" />
							</g:link>
						</li>
						<li>
							<g:link class="create" action="create">
								<i class="icon-plus"></i>
								<g:message code="default.create.label" args="[entityName]" />
							</g:link>
						</li>
					</ul>
				</div>
			</div>
			
			<div class="span9">

				<div class="page-header">
					<h1><g:message code="default.show.label" args="[entityName]" /></h1>
				</div>

				<g:if test="${flash.message}">
				<bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert>
				</g:if>

				<dl>
					<g:if test="${orgInstance?.name}">
						<dt><g:message code="org.name.label" default="Name" /></dt>
						
							<dd><g:fieldValue bean="${orgInstance}" field="name"/></dd>
						
					</g:if>
				
					<g:if test="${orgInstance?.address}">
						<dt><g:message code="org.address.label" default="Address" /></dt>
						
							<dd><g:fieldValue bean="${orgInstance}" field="address"/></dd>
						
					</g:if>
				
					<g:if test="${orgInstance?.ipRange}">
						<dt><g:message code="org.ipRange.label" default="Ip Range" /></dt>
						
							<dd><g:fieldValue bean="${orgInstance}" field="ipRange"/></dd>
						
					</g:if>
				
					<g:if test="${orgInstance?.sector}">
						<dt><g:message code="org.sector.label" default="Sector" /></dt>
						
							<dd><g:fieldValue bean="${orgInstance}" field="sector"/></dd>
						
					</g:if>
				
					<g:if test="${orgInstance?.ids}">
						<dt><g:message code="org.ids.label" default="Ids" /></dt>
							<g:each in="${orgInstance.ids}" var="i">
							<dd><g:link controller="identifierOccurrence" action="show" id="${i.id}">${i?.identifier?.ns?.ns?.encodeAsHTML()} : ${i?.identifier?.value?.encodeAsHTML()}</g:link></dd>
							</g:each>
					</g:if>

                                        <g:if test="${orgInstance?.outgoingCombos}">
                                          <dt><g:message code="org.outgoingCombos.label" default="Outgoing Combos" /></dt>
					  <g:each in="${orgInstance.outgoingCombos}" var="i">
                                            <dd>${i.type.value} ${i.toOrg?.name}</dd>
					</g:each>
					</g:if>

                                        <g:if test="${orgInstance?.incomingCombos}">
                                          <dt><g:message code="org.incomingCombos.label" default="Incoming Combos" /></dt>
					  <g:each in="${orgInstance.incomingCombos}" var="i">
                                            <dd>${i.type.value} ${i.fromOrg?.name}</dd>
					</g:each>
					</g:if>

				
					<g:if test="${orgInstance?.impId}">
						<dt><g:message code="org.impId.label" default="Imp Id" /></dt>
						
							<dd><g:fieldValue bean="${orgInstance}" field="impId"/></dd>
						
					</g:if>
				
				
				</dl>

				<g:form>
					<g:hiddenField name="id" value="${orgInstance?.id}" />
					<div class="form-actions">
						<g:link class="btn" action="edit" id="${orgInstance?.id}">
							<i class="icon-pencil"></i>
							<g:message code="default.button.edit.label" default="Edit" />
						</g:link>
						<button class="btn btn-danger" type="submit" name="_action_delete">
							<i class="icon-trash icon-white"></i>
							<g:message code="default.button.delete.label" default="Delete" />
						</button>
					</div>
				</g:form>

			</div>

		</div>
	</body>
</html>