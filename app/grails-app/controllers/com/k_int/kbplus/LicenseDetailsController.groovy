package com.k_int.kbplus

import grails.converters.*
import grails.plugins.springsecurity.Secured
import org.elasticsearch.groovy.common.xcontent.*
import groovy.xml.StreamingMarkupBuilder
import com.k_int.kbplus.auth.*;
import org.codehaus.groovy.grails.plugins.orm.auditable.AuditLogEvent
import org.springframework.security.access.annotation.Secured

@Mixin(com.k_int.kbplus.mixins.PendingChangeMixin)
class LicenseDetailsController {

  def springSecurityService
  def docstoreService
  def ESWrapperService
  def gazetteerService
  def alertsService
  def genericOIDService
  def transformerService
  def exportService

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def index() {
    log.debug("licenseDetails id:${params.id}");
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    // result.institution = Org.findByShortcode(params.shortcode)
    result.license = License.get(params.id)

    if ( ! result.license.hasPerm("view",result.user) ) {
      log.debug("return 401....");
      response.sendError(401);
      return
    }

    if ( result.license.hasPerm("edit",result.user) ) {
      result.editable = true
    }
    else {
      result.editable = false
    }
	
    def license_reference_str = result.license.reference?:'NO_LIC_REF_FOR_ID_'+params.id

    def filename = "licenceDetails_${license_reference_str.replace(" ", "_")}"
    result.onixplLicense = result.license.onixplLicense;

    withFormat {
		  html result
		  json {
			  def map = exportService.addLicensesToMap([:], [result.license])
			  
			  def json = map as JSON
			  if(params.transforms){
				  transformerService.triggerTransform(result.user, filename, params.transforms, json.toString(), response)
			  }else{
				  response.setHeader("Content-disposition", "attachment; filename=\"${filename}.json\"")
				  response.contentType = "application/json"
				  render json.toString()
			  }
		  }
		  xml {
			  def doc = exportService.buildDocXML("Licences")
			  exportService.addLicencesIntoXML(doc, doc.getDocumentElement(), [result.license])
			  
			  if(params.transforms){
				  String xml = exportService.streamOutXML(doc, new StringWriter()).getWriter().toString();
				  transformerService.triggerTransform(result.user, filename, params.transforms, xml, response)
			  }else{
				  response.setHeader("Content-disposition", "attachment; filename=\"${filename}.xml\"")
				  response.contentType = "text/xml"
				  exportService.streamOutXML(doc, response.outputStream)
			  }
		  }
    }
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def links() {
    log.debug("licenseDetails id:${params.id}");
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    // result.institution = Org.findByShortcode(params.shortcode)
    result.license = License.get(params.id)

    if ( result.license.hasPerm("edit",result.user) ) {
      result.editable = true
    }
    else {
      result.editable = false
    }


    if ( ! result.license.hasPerm("view",result.user) ) {
      response.sendError(401);
      return
    }

    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def history() {
    log.debug("licenseDetails id:${params.id}");
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    result.license = License.get(params.id)

    if ( ! result.license.hasPerm("view",result.user) ) {
      response.sendError(401);
      return
    }

    if ( result.license.hasPerm("edit",result.user) ) {
      result.editable = true
    }
    else {
      result.editable = false
    }

    result.max = params.max ?: 20;
    result.offset = params.offset ?: 0;

    def qry_params = [result.license.class.name, "${result.license.id}"]
    result.historyLines = AuditLogEvent.executeQuery("select e from AuditLogEvent as e where className=? and persistedObjectId=? order by id desc", qry_params, [max:result.max, offset:result.offset]);
    result.historyLinesTotal = AuditLogEvent.executeQuery("select count(e.id) from AuditLogEvent as e where className=? and persistedObjectId=?",qry_params)[0];

    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def notes() {
    log.debug("licenseDetails id:${params.id}");
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    // result.institution = Org.findByShortcode(params.shortcode)
    result.license = License.get(params.id)

    if ( ! result.license.hasPerm("view",result.user) ) {
      response.sendError(401);
      return
    }

    if ( result.license.hasPerm("edit",result.user) ) {
      result.editable = true
    }
    else {
      result.editable = false
    }
    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def documents() {
    log.debug("licenseDetails id:${params.id}");
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    result.license = License.get(params.id)

    if ( ! result.license.hasPerm("view",result.user) ) {
      response.sendError(401);
      return
    }

    if ( result.license.hasPerm("edit",result.user) ) {
      result.editable = true
    }
    else {
      result.editable = false
    }
    result
  }



  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def uploadDocument() {
    log.debug("upload document....");

    def user = User.get(springSecurityService.principal.id)

    def l = License.get(params.licid);

    if ( ! l.hasPerm("edit",result.user) ) {
      response.sendError(401);
      return
    }

    def input_stream = request.getFile("upload_file")?.inputStream
    def original_filename = request.getFile("upload_file")?.originalFilename

    log.debug("uploadDocument ${params} upload file = ${original_filename}");

    if ( l && input_stream ) {
      def docstore_uuid = docstoreService.uploadStream(input_stream, original_filename, params.upload_title)
      log.debug("Docstore uuid is ${docstore_uuid}");

      if ( docstore_uuid ) {
        log.debug("Docstore uuid present (${docstore_uuid}) Saving info");
        def doc_content = new Doc(contentType:1,
                                  uuid: docstore_uuid,
                                  filename: original_filename,
                                  mimeType: request.getFile("upload_file")?.contentType,
                                  title: params.upload_title,
                                  type:RefdataCategory.lookupOrCreate('Document Type',params.doctype)).save()

        def doc_context = new DocContext(license:l,
                                         owner:doc_content,
                                         user: user,
                                         doctype:RefdataCategory.lookupOrCreate('Document Type',params.doctype)).save(flush:true);
      }
    }

    log.debug("Redirecting...");
    redirect controller: 'licenseDetails', action:'index', id:params.licid, fragment:params.fragment
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def deleteDocuments() {
    def ctxlist = []

    log.debug("deleteDocuments ${params}");

    def user = User.get(springSecurityService.principal.id)
    def l = License.get(params.licid);

    if ( ! l.hasPerm("edit",user) ) {
      response.sendError(401);
      return
    }

    params.each { p ->
      if (p.key.startsWith('_deleteflag.') ) {
        def docctx_to_delete = p.key.substring(12);
        log.debug("Looking up docctx ${docctx_to_delete} for delete");
        def docctx = DocContext.get(docctx_to_delete)
        docctx.status = RefdataCategory.lookupOrCreate('Document Context Status','Deleted');
        docctx.save(flush:true);
      }
    }

    redirect controller: 'licenseDetails', action:'index', params:[shortcode:params.shortcode], id:params.licid, fragment:'docstab'
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def acceptChange() {
    processAcceptChange(params, License.get(params.id), genericOIDService)
    redirect controller: 'licenseDetails', action:'index',id:params.id
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def rejectChange() {
    processRejectChange(params, License.get(params.id))
    redirect controller: 'licenseDetails', action:'index',id:params.id
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def additionalInfo() {
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    result.license = License.get(params.id)
    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def create() {
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def processNewTemplateLicense() {
    if ( params.reference && ( ! params.reference.trim().equals('') ) ) {

      def template_license_type = RefdataCategory.lookupOrCreate('License Type','Template');
      def license_status_current = RefdataCategory.lookupOrCreate('License Status','Current');
      
      def new_template_license = new License(reference:params.reference,
                                             type:template_license_type,
                                             status:license_status_current).save(flush:true);
      redirect(action:'index', id:new_template_license.id);
    }
    else {
      redirect(action:'create');
    }
  }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def onixpl() {
        def user = User.get(springSecurityService.principal.id)
        def license = License.get(params.id);
        def onixplLicense = license.onixplLicense;
        if (onixplLicense==null) return false;
        if ( ! onixplLicense.hasPerm("view",user) ) {
            log.debug("return 401....");
            response.sendError(401);
            return
        }
        def editable = onixplLicense.hasPerm("edit", user)
        [license: license, onixplLicense: onixplLicense, user: user, editable: editable]
    }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def unlinkLicense() {
        License license = License.get(params.license_id);
        OnixplLicense opl = license.onixplLicense;
        String oplTitle = opl.title;
        DocContext dc = DocContext.findByOwner(opl.doc);
        Doc doc = opl.doc;
        license.removeFromDocuments(dc);
        opl.removeFromLicenses(license);
        // If there are no more links to this ONIX-PL License then delete the license and
        // associated data
        if (opl.licenses.isEmpty()) {
            dc.delete();
            opl.delete();
            docstoreService.deleteDocs([doc.uuid]);
            doc.delete();
        }
        if (license.hasErrors()) {
            license.errors.each {
                log.error("License error: " + it);
            }
            flash.message = "An error occurred when unlinking the ONIX-PL license '${oplTitle}'";
        } else {
            flash.message = "The ONIX-PL license '${oplTitle}' was unlinked successfully";
        }
        redirect(action: 'index', id: license.id);
    }
}
