<!doctype html>
<html>
  <head>
    <meta name="layout" content="mmbootstrap"/>
    <title>KB+ Data import explorer</title>
  </head>
  <body>

    <div class="container">
        <ul class="breadcrumb">
            <li> <g:link controller="home" action="index">Home</g:link> <span class="divider">/</span> </li>
           <li> <g:link controller="myInstitutions" action="addLicense" params="${[shortcode:params.shortcode]}">${institution.name} Add License</g:link> </li>
        </ul>
    </div>

    <div class="container">
      <h1>${institution?.name} - Licences</h1>
      <ul class="nav nav-pills">
       <li><g:link controller="myInstitutions" 
                                  action="currentLicenses" 
                                  params="${[shortcode:params.shortcode]}">Current Licences</g:link></li>

        <li class="active"><g:link controller="myInstitutions" 
                                action="addLicense" 
                                params="${[shortcode:params.shortcode]}">Add Licence</g:link></li>
      </ul>

    </div>

    <div class="container licence-searches">
        <div class="row">
            <div class="span6">&nbsp;
                <!--
                <input type="text" name="keyword-search" placeholder="enter search term..." />
                <input type="submit" class="btn btn-primary" value="Search" />
                -->
            </div>
            <div class="span6">
                <div class="pull-right">
                  <g:if test="${is_admin}">
                    <g:link controller="myInstitutions" action="cleanLicense" params="${[shortcode:params.shortcode]}" class="btn btn-primary">Create New Licence</g:link>
                  </g:if>
                </div>
            </div>
        </div>
    </div>

      <div class="container">
        <g:form action="addLicense" params="${params}" method="get" class="form-inline">
          <input type="hidden" name="sort" value="${params.sort}">
          <input type="hidden" name="order" value="${params.order}">
          <label>Filters - License Name:</label> <input name="filter" value="${params.filter}"/> &nbsp;
          <input type="submit" class="btn btn-primary">
        </g:form>
      </div>

    <g:form action="actionLicenses"
            controller="myInstitutions" 
            params="${[shortcode:params.shortcode]}">

      <div class="container">
          <div class="well licence-options">
            <g:if test="${is_admin}">
              <input type="submit" name="copy-licence" value="Copy Selected" class="btn btn-warning" />
            </g:if>
            <g:else>Sorry, you must have editor role to be able to add licences</g:else>
          </div>
      </div>

      <g:if test="${flash.message}">
        <div class="container">
          <bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert>
        </div>
      </g:if>

      <g:if test="${flash.error}">
        <div class="container">
          <bootstrap:alert class="error-info">${flash.error}</bootstrap:alert>
        </div>
      </g:if>


      <g:if test="${licenses?.size() > 0}">
        <div class="container licence-results">
          <table class="table table-bordered table-striped">
            <thead>
              <tr>
                <th>Select</th>
                <g:sortableColumn params="${params}" property="reference" title="Reference Description" />
                <th>Licensor</th>
                <g:sortableColumn params="${params}" property="status.value" title="Status" />
                <g:sortableColumn params="${params}" property="type.value" title="Type" />
              </tr>
            </thead>
            <tbody>
              <g:each in="${licenses}" var="l">
                <tr>
                  <td><input type="radio" name="baselicense" value="${l.id}"/></td>
                  <td><g:link action="index"
                              controller="licenseDetails" 
                              id="${l.id}">${l.reference?:"License ${l.id} - no reference set"}</g:link></td>
                  <td>${l.licensor?.name}</td>
                  <td>${l.status?.value}</td>
                  <td>${l.type?.value}</td>
                </tr>
              </g:each>
            </tbody>
          </table>

          <div class="pagination" style="text-align:center">
            <g:if test="${licenses}" >
              <bootstrap:paginate  action="addLicense" controller="myInstitutions" params="${params}" next="Next" prev="Prev" max="${max}" total="${numLicenses}" />
            </g:if>
          </div>
        </div>

      </g:if>
    </g:form>

    <script type="text/javascript">
        $('.licence-results input[type="radio"]').click(function () {
            $('.licence-options').slideDown('fast');
        });

        $('.licence-options .delete-licence').click(function () {
            $('.licence-results input:checked').each(function () {
                $(this).parent().parent().fadeOut('slow');
                $('.licence-options').slideUp('fast');
            })
        })
    </script>

  </body>
</html>
