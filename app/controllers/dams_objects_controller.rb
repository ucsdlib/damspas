require 'net/http'
require 'json'

class DamsObjectsController < ApplicationController
  include Blacklight::Catalog
  include Dams::ControllerHelper
  load_and_authorize_resource
  #skip_load_resource :only => :show
  skip_load_and_authorize_resource :only => [:show, :zoom]

  ##############################################################################
  # solr actions ###############################################################
  ##############################################################################
  def show
    # update session counter, then redirect to URL w/o counter param
    if params[:counter]
      session[:search][:counter] = params[:counter]
      redirect_to dams_object_path(params[:id])
      return
    end

    # check ip for unauthenticated users
    if current_user == nil
      current_user = User.anonymous(request.ip)
    end

    # import solr config from catalog_controller and setup next/prev docs
    @blacklight_config = CatalogController.blacklight_config
    DamsObjectsController.solr_search_params_logic += [:add_access_controls_to_solr_params]
    setup_next_and_previous_documents

    # get metadata from solr
    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )

    # enforce access controls
    authorize! :show, @document

    if @document.nil?
      raise ActionController::RoutingError.new('Not Found')
    end

    @rdfxml = @document['rdfxml_ssi']
    if @rdfxml == nil
      @rdfxml = "<rdf:RDF xmlns:dams='http://library.ucsd.edu/ontology/dams#'
          xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'
          rdf:about='#{Rails.configuration.id_namespace}#{params[:id]}'>
  <dams:error>content missing</dams:error>
</rdf:RDF>"
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @document }
      format.rdf { render xml: @rdfxml }
    end
  end
  def index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:DamsObject"', :rows => 100 )
  end
  def zoom
    # check ip for unauthenticated users
    if current_user == nil
      current_user = User.anonymous(request.ip)
    end

    # get metadata from solr
    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )

    # enforce access controls
    authorize! :show, @document

    @object = params[:id]
    @component = params[:cmp]

    render layout: 'minimal'
  end


  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def view
    @dams_object = DamsObject.find(params[:id])
  end

  def new
    @dams_object.title.build
    @dams_object.title.first.elementList.subTitleElement.build
    @dams_object.title.first.hasVariant.build
    @dams_object.title.first.hasTranslationVariant.build
    @dams_object.title.first.hasAbbreviationVariant.build
    @dams_object.title.first.hasAcronymVariant.build
    @dams_object.title.first.hasExpansionVariant.build
    @dams_object.date.build
    @dams_object.language.build
    #@dams_object.language.first.scheme.build
    @dams_object.note.build
    @dams_object.scopeContentNote.build
    @dams_object.custodialResponsibilityNote.build
    @dams_object.preferredCitationNote.build
    @dams_object.relatedResource.build
    @dams_object.cartographics.build
    @dams_object.complexSubject.build
    @dams_object.builtWorkPlace.build
    @dams_object.culturalContext.build
    @dams_object.function.build    
    @dams_object.genreForm.build
    @dams_object.geographic.build
    @dams_object.iconography.build    
    @dams_object.occupation.build
    @dams_object.scientificName.build
    @dams_object.stylePeriod.build    
    @dams_object.technique.build   
    @dams_object.topic.build    
    @dams_object.temporal.build     
	@dams_object.name.build
    @dams_object.personalName.build    
    @dams_object.corporateName.build   
    @dams_object.conferenceName.build    
    @dams_object.familyName.build
    @dams_object.unit.build
    @dams_object.assembledCollection.build    
    @dams_object.provenanceCollection.build
    @dams_object.provenanceCollectionPart.build
    @dams_object.copyright.build
    @dams_object.license.build    
    @dams_object.statute.build
    @dams_object.rightsHolderPersonal.build
    #@dams_object.rightsHolderCorporate.build
    #@dams_object.otherRights.build
    @dams_object.relationship.build
    @dams_object.relationship.first.role.build
    @dams_object.relationship.first.personalName.build
    @dams_object.relationship.first.name.build
    @dams_object.relationship.first.corporateName.build
    @dams_object.relationship.first.conferenceName.build
    @dams_object.relationship.first.familyName.build

                        
  	@mads_complex_subjects = get_objects_url('MadsComplexSubject','name_tesim')
  	@mads_complex_subjects << "Create New Complex Subject"
  	@dams_units = get_objects_url('DamsUnit','unit_name_tesim') 	
  	@dams_assembled_collections = get_objects_url('DamsAssembledCollection','title_tesim')
  	@dams_provenance_collections = get_objects_url('DamsProvenanceCollection','title_tesim')
  	@mads_languages =  get_objects_url('MadsLanguage','name_tesim')
  	@mads_languages << "Create New Language"
  	@mads_authorities = get_objects_url('MadsAuthority','name_tesim')
  	@dams_copyrights = get_objects_url('DamsCopyright','status_tesim')
  	@dams_statutes = get_objects_url('DamsStatute','citation_tesim')
  	@dams_other_rights = get_objects('DamsOtherRight','uri_tesim')
  	@dams_licenses = get_objects_url('DamsLicense','note_tesim')
  	@dams_personal_names = get_objects_url('MadsPersonalName','name_tesim')
  	@dams_corporate_names = get_objects_url('MadsCorporateName','name_tesim')
  	@dams_names = get_objects_url('MadsName','name_tesim')
  	@dams_family_names = get_objects_url('MadsFamilyName','name_tesim')
  	@dams_conference_names = get_objects_url('MadsConferenceName','name_tesim')
  	@dams_provenance_collection_parts=get_objects_url('DamsProvenanceCollectionPart','title_tesim')
  	@mads_schemes = get_objects('MadsScheme','name_tesim')
  		
	uri = URI('http://fast.oclc.org/fastSuggest/select')
	res = Net::HTTP.post_form(uri, 'q' => 'suggestall :*', 'fl' => 'suggestall', 'wt' => 'json', 'rows' => '100')
	json = JSON.parse(res.body)
	@jdoc = json.fetch("response").fetch("docs")
	
	@autocomplete_items = Array.new
	@jdoc.each do |value|
		@autocomplete_items << value['suggestall']
	end 
	
  end
  
  def edit
    @dams_object = DamsObject.find(params[:id])
	#@mads_complex_subjects = get_objects('MadsComplexSubject','name_tesim')
	@mads_complex_subjects = get_objects_url('MadsComplexSubject','name_tesim')
	@mads_complex_subjects << "Create New Complex Subject"
	@dams_provenance_collection_parts=get_objects('DamsProvenanceCollectionPart','title_tesim')
	@provenance_collection_part_id = @dams_object.provenanceCollectionPart.to_s.gsub(/.*\//,'')[0..9] if !@dams_object.provenanceCollectionPart.nil?
	@dams_units = get_objects('DamsUnit','unit_name_tesim')
  	@dams_assembled_collections = get_objects('DamsAssembledCollection','title_tesim')
  	@dams_provenance_collections = get_objects('DamsProvenanceCollection','title_tesim')
  	@mads_languages =  get_objects_url('MadsLanguage','name_tesim')
  	@mads_languages << "Create New Language"
  	@mads_authorities = get_objects('MadsAuthority','name_tesim')
  	@dams_copyrights = get_objects('DamsCopyright','status_tesim')
  	@dams_statutes = get_objects('DamsStatute','citation_tesim')
  	@dams_other_rights = get_objects('DamsOtherRight','basis_tesim')
  	@dams_licenses = get_objects('DamsLicense','note_tesim')
  	@dams_rightsHolders = get_objects('MadsPersonalName','name_tesim')
  	 	
  	@unit_id = @dams_object.unit.to_s.gsub(/.*\//,'')[0..9]
  	#@assembled_collection_id = @dams_object.assembledCollectionURI.to_s.gsub(/.*\//,'')[0..9]
  	#@provenance_collection_id = @dams_object.provenanceCollectionURI.to_s.gsub(/.*\//,'')[0..9]
  	
  	@language_id = @dams_object.language.to_s.gsub(/.*\//,'')[0..9]
  	@role_id = @dams_object.relationshipRoleURI.to_s.gsub(/.*\//,'')[0..9]  	
  	@name_id = get_relationship_name_id(@dams_object)
  	@name_type = get_relationship_name_type(@dams_object)
  	@dams_names = get_objects("Mads#{@name_type}",'name_tesim')
  	@nameTypeArray = Array.new
  	@nameTypeArray << @name_type
  	@dams_object.relationshipNameType = @nameTypeArray
  	
  	@copyright_id = @dams_object.copyrights.pid if !@dams_object.copyrights.nil?
  	@statute_id = @dams_object.statutes.pid if !@dams_object.statutes.nil?
  	@otherRight_id = @dams_object.otherRights.pid if !@dams_object.otherRights.nil?
  	@license_id = @dams_object.licenses.pid if !@dams_object.licenses.nil?
  	@rightsHolder_id = @dams_object.rightsHolders.first.pid if !@dams_object.rightsHolders.first.nil?
  	 	
  	@simple_subject_type = get_simple_subject_type(@dams_object) 	
  	@dams_simple_subjects = get_objects(@simple_subject_type,'name_tesim')
  	#@simpleSubject_id = @dams_object.topic.to_s.gsub(/.*\//,'')[0..9] if !@dams_object.topic.nil? 
  	@simpleSubject_id = get_simple_subject_id(@dams_object)  
  	#@complexSubject_id = Rails.configuration.id_namespace + @dams_object.complexSubject.to_s.gsub(/.*\//,'')[0..9] if !@dams_object.subject.nil?
  	@complexSubject_id = @dams_object.complexSubject.to_s.gsub(/.*\//,'')[0..9] if !@dams_object.subject.nil?
	@simpleSubjectValue = get_simple_subject_value(@dams_object)
	  
	@simple_name_type = get_name_type(@dams_object)
	@simple_name_id = get_name_id(@dams_object) 	
  	@simple_names = get_objects("Mads#{@simple_name_type}",'name_tesim') 	
  	@simple_name_value = get_name_value(@dams_object)
  	 
  	@dams_object.collections.each do |col|
  		if(col.class == DamsAssembledCollection)	
  			@assembled_collection_id = col.pid
  		elsif (col.class == DamsProvenanceCollection)
  			@provenance_collection_id = col.pid
  		end  			
  	end


	uri = URI('http://fast.oclc.org/fastSuggest/select')
	res = Net::HTTP.post_form(uri, 'q' => 'suggestall :*', 'fl' => 'suggestall', 'wt' => 'json', 'rows' => '100')
	json = JSON.parse(res.body)
	@jdoc = json.fetch("response").fetch("docs")
	
	@autocomplete_items = Array.new
	@jdoc.each do |value|
		@autocomplete_items << value['suggestall']
	end   	 	 
  end
  
  def create    	    
  	if @dams_object.save 
        flash[:notice] = "Object has been saved"
        # check for file upload
        if params[:file]
          file_status = attach_file( @dams_object, params[:file] )
          flash[:alert] = file_status[:alert] if file_status[:alert]
          flash[:deriv] = file_status[:deriv] if file_status[:deriv]
        end
  		redirect_to @dams_object
    else
      flash[:alert] = "Unable to save object"
      render :new
    end
  end
  
  def update
  	@dams_object.title.clear
  	@dams_object.date.clear
  	@dams_object.language.clear
    @dams_object.note.clear
    @dams_object.scopeContentNote.clear
    @dams_object.custodialResponsibilityNote.clear
    @dams_object.preferredCitationNote.clear
    @dams_object.relatedResource.clear
    @dams_object.cartographics.clear
    @dams_object.complexSubject.clear
    @dams_object.builtWorkPlace.clear
    @dams_object.culturalContext.clear
    @dams_object.function.clear    
    @dams_object.genreForm.clear
    @dams_object.geographic.clear
    @dams_object.iconography.clear    
    @dams_object.occupation.clear
    @dams_object.scientificName.clear
    @dams_object.stylePeriod.clear    
    @dams_object.technique.clear   
    @dams_object.topic.clear
    @dams_object.temporal.clear
	@dams_object.name.clear
    @dams_object.personalName.clear    
    @dams_object.corporateName.clear   
    @dams_object.conferenceName.clear    
    @dams_object.familyName.clear
    @dams_object.unit.clear
    @dams_object.assembledCollection.clear   
    @dams_object.provenanceCollection.clear
    @dams_object.provenanceCollectionPart.clear
    @dams_object.copyright.clear
    @dams_object.license.clear  
    @dams_object.statute.clear
    #@dams_object.otherRights.clear

    @dams_object.attributes = params[:dams_object]
  	if @dams_object.save
  		redirect_to @dams_object, notice: "Successfully updated object"
  		#redirect_to edit_dams_object_path(@dams_object), notice: "Successfully updated object"	
    else
      flash[:alert] = "Unable to save object"
      render :edit
    end
  end
end
