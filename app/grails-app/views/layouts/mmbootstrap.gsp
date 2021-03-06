<%@ page import="org.codehaus.groovy.grails.web.servlet.GrailsApplicationAttributes" %>
<!doctype html>

<!--[if lt IE 7]> <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>    <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>    <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->

<html lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title><g:layoutTitle default="${meta(name: 'app.name')}"/></title>
    <meta name="description" content="">
    <meta name="viewport" content="initial-scale = 1.0">
    <r:require modules="kbplus"/>
    <g:layoutHead/>
    <!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->
    
    <!-- Le fav and touch icons -->
    <link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}" type="image/x-icon">


    <!-- Stylesheets -->
    <r:layoutResources/>
    <r:layoutResources/>
  </head>

  <body>

    <div class="navbar navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
          <g:link controller="home" action="index" class="brand" alt="KB+ ${grailsApplication.metadata.'app.version'} / build ${grailsApplication.metadata.'app.buildNumber'}">KB+</g:link>
          <div class="nav-collapse">
            <ul class="nav">
              <sec:ifLoggedIn>

                <sec:ifAnyGranted roles="ROLE_ADMIN">
                  <li class="dropdown">
                    <a href="#" class="dropdown-toggle explorer-link" data-toggle="dropdown"> Data Explorer <b class="caret"></b> </a>
                    <ul class="dropdown-menu" style="max-width:none;">
                      <li<%= request.forwardURI == "${createLink(uri: '/home/search')}" ? ' class="active"' : '' %>><a href="${createLink(uri: '/home/search')}">Search</a></li>
                      <li <%='package'== controllerName ? ' class="active"' : '' %>><g:link controller="package">Package</g:link></li>
                      <li <%='org'== controllerName ? ' class="active"' : '' %>><g:link controller="org">Organisations</g:link></li>
                      <li <%='platform'== controllerName ? ' class="active"' : '' %>><g:link controller="platform">Platform</g:link></li>
                      <li <%='titleInstance'== controllerName ? ' class="active"' : '' %>><g:link controller="titleInstance">Title Instance</g:link></li>
                      <li <%='titleInstancePackagePlatform'== controllerName ? ' class="active"' : '' %>><g:link controller="titleInstancePackagePlatform">Title Instance Package Platform</g:link></li>
                      <li <%='subscription'== controllerName ? ' class="active"' : '' %>><g:link controller="subscription">Subscriptions</g:link></li>
                      <li <%='license'== controllerName ? ' class="active"' : '' %>><g:link controller="license">Licences</g:link></li>
                      <li <%='onixplLicenseDetails'== controllerName ? ' class="active"' : '' %>><g:link controller="onixplLicenseDetails" action="list">ONIX-PL Licences</g:link></li>
                    </ul>
                  </li>
                </sec:ifAnyGranted>
  
                <g:if test="${user}">
                  <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown"> Manage <b class="caret"></b> </a>
                    <ul class="dropdown-menu" style="max-width:none;">
  
  
                       <li><g:link controller="packageDetails" action="index">All Packages</g:link></li>
                       <li><g:link controller="titleDetails" action="index">All Titles</g:link></li>
                       <li><g:link controller="onixplLicenseCompare"
                                   action="index">Compare ONIX-PL Licences</g:link></li>
                       <li class="divider"></li>
                       <g:set var="usaf" value="${user.authorizedOrgs}" />
                       <g:if test="${usaf && usaf.size() > 0}">
                         <g:each in="${usaf}" var="org">
                           <li class="dropdown-submenu">
                             <a href="#" class="dropdown-toggle" data-toggle="dropdown">${org.name}</i> </a>
                             <ul class="dropdown-menu">
                               <li><g:link controller="myInstitutions" 
                                           action="instdash" 
                                           params="${[shortcode:org.shortcode]}">Dashboard</g:link></li>
                               <li><g:link controller="myInstitutions" 
                                           action="currentLicenses" 
                                           params="${[shortcode:org.shortcode]}">Licences</g:link></li>
                               <li><g:link controller="myInstitutions" 
                                           action="currentSubscriptions" 
                                           params="${[shortcode:org.shortcode]}">Subscriptions</g:link></li>
                               <li><g:link controller="myInstitutions" 
                                           action="currentTitles" 
                                           params="${[shortcode:org.shortcode]}">Titles</g:link></li>
                               <li><g:link controller="myInstitutions" 
                                           action="renewalsSearch" 
                                           params="${[shortcode:org.shortcode]}">Generate Renewals Worksheet</g:link></li>
                               <li><g:link controller="myInstitutions" 
                                           action="renewalsUpload" 
                                           params="${[shortcode:org.shortcode]}">Import Renewals</g:link></li>
                               <li><g:link controller="organisations"
                                           action="show" 
                                           params="${[id:org.id]}">Organisation Information</g:link></li>
                               <li><g:link controller="subscriptionImport" 
                                           action="generateImportWorksheet"
                                           params="${[id:org.id]}">Generate Subscription Taken Worksheet</g:link></li>
                               <li><g:link controller="subscriptionImport" 
                                           action="importSubscriptionWorksheet"
                                           params="${[id:org.id]}">Import Subscription Taken Worksheet</g:link></li>

                             </ul>
                           </li>
                         </g:each>
                       </g:if>
                       <g:else>
                         <li>Please request institutional affiliations via your <g:link controller="profile" action="index">Profile Page</g:link></li>
                       </g:else>
                       <li class="divider"></li>
                       <li><a href="https://knowledgebaseplus.wordpress.com/kb-support/">Help</a></li>
                    </ul>
                  </li>
                </g:if>

                <sec:ifAnyGranted roles="ROLE_ADMIN,KBPLUS_EDITOR">
                   <li class="dropdown">
                     <a href="#" class="dropdown-toggle" data-toggle="dropdown"> Editors <b class="caret"></b> </a>
                     <ul class="dropdown-menu">
                       <li <%= ( ( 'announcement'== controllerName ) && ( 'index'==actionName ) ) ? ' class="active"' : '' %>>
                         <g:link controller="announcement" action="index">Announcements</g:link></li>
                       <li <%= ( ( 'packageDetails'== controllerName ) && ( 'list'==actionName ) ) ? ' class="active"' : '' %>>
                         <g:link controller="packageDetails" action="list">Search Packages</g:link></li>
                       <!--
                       <li <%= ( ( 'packageDetails'== controllerName ) && ( 'create'==actionName ) ) ? ' class="active"' : '' %>>
                         <g:link controller="packageDetails" action="create">New Package</g:link></li>
                       -->
                       <li class="divider"></li>
                         <li <%= ( ( 'upload'== controllerName ) && ( 'reviewSO'==actionName ) ) ? ' class="active"' : '' %>>
                             <g:link controller="upload" action="reviewSO">Upload new Package</g:link></li>
                         <li <%= ( ( 'licenseImport'== controllerName ) && ( 'doImport'==actionName ) ) ? ' class="active"' : '' %>>
                             <g:link controller="licenseImport" action="doImport">Import ONIX-PL license</g:link></li>
                       <li class="divider"></li>
                       <li <%= ( ( 'titleDetails'== controllerName ) && ( 'findTitleMatches'==actionName ) ) ? ' class="active"' : '' %>>
                         <g:link controller="titleDetails" action="findTitleMatches">New Title</g:link></li>
                       <li <%= ( ( 'licenseDetails'== controllerName ) && ( 'create'==actionName ) ) ? ' class="active"' : '' %>>
                         <g:link controller="licenseDetails" action="create">New License</g:link></li>
                       <li class="divider"></li>
                       <li <%= ( ( 'subscriptionImport'== controllerName ) && ( 'generateImportWorksheet'==actionName ) ) ? ' class="active"' : '' %>>
                         <g:link controller="subscriptionImport" action="generateImportWorksheet">Generate Subscription Taken Worksheet</g:link></li>
                       <li <%= ( ( 'subscriptionImport'== controllerName ) && ( 'importSubscriptionWorksheet'==actionName ) ) ? ' class="active"' : '' %>>
                         <g:link controller="subscriptionImport" action="importSubscriptionWorksheet">Import Subscription Taken Worksheet</g:link></li>
                     </ul>
                   </li>
                </sec:ifAnyGranted>

  
                <sec:ifAnyGranted roles="ROLE_ADMIN">
                   <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown"> Admin Actions <b class="caret"></b> </a>
                    <ul class="dropdown-menu">
                      <li <%= ( ( 'admin'== controllerName ) && ( 'manageAffiliationRequests'==actionName ) ) ? ' class="active"' : '' %>>
                         <g:link controller="admin" action="manageAffiliationRequests">Manage Affiliation Requests</g:link></li>
                      <li <%= ( ( 'admin'== controllerName ) && ( 'settings'==actionName ) ) ? ' class="active"' : '' %>>
                         <g:link controller="admin" action="settings">System Settings</g:link></li>
                      <li class="divider"></li>
                      <li <%= ( ( 'organisations'== controllerName ) && ( 'index'==actionName ) ) ? ' class="active"' : '' %>>
                         <g:link controller="organisations" action="index">Manage Organisations</g:link>
                      </li>
                      <li <%= ( ( 'startFTIndex'== controllerName ) && ( 'index'==actionName ) ) ? ' class="active"' : '' %>>
                         <g:link controller="startFTIndex" action="index">Start FT Index Update</g:link>
                      </li>
                      <li <%= ( ( 'admin'== controllerName ) && ( 'showAffiliations'==actionName ) ) ? ' class="active"' : '' %>>
                         <g:link controller="admin" action="showAffiliations">Show Affiliations</g:link>
                      </li>
                      <li <%= ( ( 'admin'== controllerName ) && ( 'allNotes'==actionName ) ) ? ' class="active"' : '' %>>
                         <g:link controller="admin" action="allNotes">All Notes</g:link>
                      </li>
                      <li <%= ( ( 'admin'== controllerName ) && ( 'dataCleanse'==actionName ) ) ? ' class="active"' : '' %>>
                         <g:link controller="admin" action="dataCleanse">Run Data Cleaning (Nominal Platforms)</g:link>
                      </li>
                      <li <%= ( ( 'admin'== controllerName ) && ( 'titleAugment'==actionName ) ) ? ' class="active"' : '' %>>
                         <g:link controller="admin" action="titleAugment">Run Data Cleaning (Title Augment)</g:link>
                      </li>
                      <li <%= ( ( 'admin'== controllerName ) && ( 'fullReset'==actionName ) ) ? ' class="active"' : '' %>>
                         <g:link controller="admin" action="fullReset">Run Full ES Index Reset</g:link>
                      </li>
                      <li <%= ( ( 'userDetails'== controllerName ) && ( 'list'==actionName ) ) ? ' class="active"' : '' %>>
                         <g:link controller="userDetails" action="list">User Details</g:link>
                      </li>
                      <li <%= ( ( 'admin'== controllerName ) && ( 'forumSync'==actionName ) ) ? ' class="active"' : '' %>>
                         <g:link controller="admin" action="forumSync">Run Forum Sync</g:link>
                      </li>
                      <li <%= ( ( 'admin'== controllerName ) && ( 'juspSync'==actionName ) ) ? ' class="active"' : '' %>>
                         <g:link controller="admin" action="juspSync">Run JUSP Sync</g:link>
                      </li>
                      <li <%= ( ( 'admin'== controllerName ) && ( 'manageContentItems'==actionName ) ) ? ' class="active"' : '' %>>
                         <g:link controller="admin" action="manageContentItems">Manage Content Items</g:link>
                      </li>
                      <li <%= ( ( 'admin'== controllerName ) && ( 'forceSendNotifications'==actionName ) ) ? ' class="active"' : '' %>>
                         <g:link controller="admin" action="forceSendNotifications">Send Pending Notifications</g:link>
                      </li>
                      <li class="divider"></li>
                      <li <%= ( ( 'stats'== controllerName ) && ( 'statsHome'==actionName ) ) ? ' class="active"' : '' %>>
                         <g:link controller="stats" action="statsHome">Statistics</g:link>
                      </li>
                    </ul>
                  </li>
  
                </sec:ifAnyGranted>
              </sec:ifLoggedIn>
            </ul>

            <!--
            <ul class="nav pull-right">
              <li><a class="dlpopover" href="#"><i class="icon-search icon-white"></i></a></li>
            </ul>
            -->

            <ul class="nav pull-right">
              <sec:ifLoggedIn>
                <g:if test="${user}">
                  <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">${user.displayName} <b class="caret"></b></a>
                    <ul class="dropdown-menu">
                      <li <%= ( ( 'profile'== controllerName ) && ( 'index'==actionName ) ) ? ' class="active"' : '' %>>
                         <g:link controller="profile" action="index">Profile</g:link></li>
                      <li><g:link controller="logout">Logout</g:link></li>
  
                    </ul>
                  </li>
                </g:if>
              </sec:ifLoggedIn>
              <sec:ifNotLoggedIn>
                <li><g:link controller="myInstitutions" action="dashboard">Login</g:link></li>
              </sec:ifNotLoggedIn>
            </ul>
          </div>
        </div>
      </div>
    </div>

   <div class="navbar-push"></div>
   <sec:ifLoggedIn>
     <g:if test="${user!=null && ( user.display==null || user.display=='' ) }">
       <div class="container">
         <bootstrap:alert class="alert-info">Your display name is not currently set in user preferences. Please <g:link controller="profile" action="index">update
            Your display name</g:link> as soon as possible.
         </bootstrap:alert>
       </div>
     </g:if>
   </sec:ifLoggedIn>

       
  <g:layoutBody/>
      
  <div id="Footer">
      <div class="navbar navbar-footer">
          <div class="navbar-inner">
              <div class="container">
                  <div>
                      <ul class="footer-sublinks nav">
                          <li><a href=${createLink(uri: '/terms-and-conditions')}>Terms & Conditions</a></li>
                          <li><a href=${createLink(uri: '/privacy-policy')}>Privacy Policy</a></li>
                          <li><a href=${createLink(uri: '/freedom-of-information-policy"')}>Freedom of Information Policy</a></li>
                      </ul>
                  </div>
                      
                  <div class="pull-right">
                      <div class="nav-collapse">
                          <ul class="nav">
                              <li class="dropdown">
                                  <a href="#"
                                     class="dropdown-toggle"
                                     data-toggle="dropdown">
                                      Tools
                                      <b class="caret"></b>
                                  </a>
                                  <ul class="dropdown-menu">
                                      <li><a href="http://www.kbplus.ac.uk/kbplus/myInstitutions/index">KB+</a></li>
                                      <li><a href="http://demo.kbplus.ac.uk/kbplus/myInstitutions/index">KB+ Demo</a></li>
                                      <li><a href="http://test.kbplus.ac.uk/kbplus/myInstitutions/index">KB+ Sandpit</a></li>
                                  </ul>
                              </li>
                          </ul>
                      </div>
                  </div>
              </div>
          </div>
      </div>
                
      <div class="clearfix"></div>
          
      <div class="footer-links container">
          <div class="row">
              <div class="pull-left">
                  <a href="http://www.jisc-collections.ac.uk/"><div class="sprite sprite-jisc_collections_logo">JISC Collections</div></a>
              </div>
              <div class="pull-right">
                  <a href="http://www.kbplus.ac.uk"><div class="sprite sprite-kbplus_logo">Knowledge Base Plus</div></a>
              </div>
          </div>
      </div>
  </div>
  
  <!--
  <div class="support-tab">
      <a href="mailto:kbplus@jisc-collections.ac.uk?subject=KBPlus%20Support%20Query"><i class="icon-question-sign icon-white"></i>Request Support</a>
  </div>
  -->
      
  <!-- For datatable -->
  <script type="text/javascript" charset="utf-8" src="http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.4/jquery.dataTables.min.js"></script>
  <script type="text/javascript" charset="utf-8" src="http://datatables.net/release-datatables/extras/Scroller/media/js/dataTables.scroller.js"></script>
      
  <!-- For x-editable -->
  <script src="${resource(dir: 'js', file: 'bootstrap-editable.js')}"></script>
      
  <!-- For select2 -->
  <script src="${resource(dir: 'js', file: 'select2.js')}"></script>
      
  <script type="text/javascript" src="//assets.zendesk.com/external/zenbox/v2.6/zenbox.js"></script>
  <style type="text/css" media="screen, projection">
    @import url(//assets.zendesk.com/external/zenbox/v2.6/zenbox.css);
  </style>
  <script type="text/javascript">
    if (typeof(Zenbox) !== "undefined") {
      Zenbox.init({
        dropboxID:   "20234067",
        url:         "https://kbplus.zendesk.com",
        tabTooltip:  "Support",
        tabImageURL: "https://assets.zendesk.com/external/zenbox/images/tab_support_right.png",
        tabColor:    "#008000",
        tabPosition: "Right"
      });
    }
  </script>

  <script type="text/javascript">
      var _gaq = _gaq || [];
      _gaq.push(['_setAccount', '${grailsApplication.config.kbplus.analytics.code}']);
      <g:if test="${params.shortcode != null}">
      _gaq.push(['_setCustomVar',
            1,                     // This custom var is set to slot #1.  Required parameter.
            'Institution',         // The name acts as a kind of category for the user activity.  Required parameter.
            "${params.shortcode}", // This value of the custom variable.  Required parameter.
            2                      // Sets the scope to session-level.  Optional parameter.
         ]);
      </g:if>
      _gaq.push(['_trackPageview']);
      (function() {
          var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
          ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
          var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
      })();
  </script>
  
    <r:layoutResources/>

    <script type="text/javascript">

      // $(function(){
      $(document).ready(function() {

        $.fn.editable.defaults.mode = 'inline';

        $('.xEditableValue').editable();
        $(".xEditableManyToOne").editable();
        $(".simpleHiddenRefdata").editable({
          url: function(params) {
            var hidden_field_id = $(this).data('hidden-id');
            $("#"+hidden_field_id).val(params.value);
            // Element has a data-hidden-id which is the hidden form property that should be set to the appropriate value
          }
        });
        
        $(".simpleReferenceTypedown").select2({
          placeholder: "Search for...",
          minimumInputLength: 1,
          ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
            url: "<g:createLink controller='ajax' action='lookup'/>",
            dataType: 'json',
            data: function (term, page) {
                return {
                    format:'json',
                    q: term,
                    baseClass:$(this).data('domain')
                };
            },
            results: function (data, page) {
              return {results: data.values};
            }
          }
        });

        $('.dlpopover').popover({html:true,
                                 placement:'bottom',
                                 title:'search', 
                                 trigger:'click', 
template: '<div class="popover" style="width: 400px;"><div class="arrow"></div><div class="popover-inner"><h3 class="popover-title"></h3><div class="popover-content"></div></div></div>',
                                 'max-width':400, 
                                 content:function() {return getContent()}});
      });

      function getContent() {
        return $('#spotlight_popover_content_wrapper').html();
        // var result=""
        // jQuery.ajax({
        //  url:"<g:createLink controller='spotlight' action='index' />",
        //  success: function(r) {
        //             result=r;
        //           },
        //  async:   false
        // });          
        // return result;
      }

      function reloadSpotlightSearchResults() {
        console.log("reload...");
        $('#spotlight-search-results').load("<g:createLink controller='spotlight' action='search' />");
      }
    </script>

    <div id="spotlight_popover_content_wrapper" style="display: none">
      <form class="form-search">
        <input type="text" class="input-medium search-query" onkeyup="reloadSpotlightSearchResults()">
      </form>
      <div id="spotlight-search-results">
      </div>
    </div>

  </body>
</html>
