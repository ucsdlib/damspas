require 'net/http'
require 'json'

class DamsObjectsController < ApplicationController
  include Blacklight::Catalog
  include Dams::ControllerHelper
  load_and_authorize_resource
  #skip_load_resource :only => :show
  skip_load_and_authorize_resource :only => :show

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
    ##XXX backing out access control enforcement
    ##authorize! :show, @document

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

  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def view
    @dams_object = DamsObject.find(params[:id])
  end

  def new
  	@mads_complex_subjects = get_objects('MadsComplexSubject','name_tesim')
  	@dams_units = get_objects('DamsUnit','unit_name_tesim') 	
  	@dams_assembled_collections = get_objects('DamsAssembledCollection','title_tesim')
  	@dams_provenance_collections = get_objects('DamsProvenanceCollection','title_tesim')
  	@mads_languages =  get_objects('MadsLanguage','name_tesim')
  	@mads_authorities = get_objects('MadsAuthority','name_tesim')
  	@dams_copyrights = get_objects('DamsCopyright','status_tesim')
  	@dams_statutes = get_objects('DamsStatute','citation_tesim')
  	@dams_other_rights = get_objects('DamsOtherRight','basis_tesim')
  	@dams_licenses = get_objects('DamsLicense','note_tesim')
  	@dams_rightsHolders = get_objects('MadsPersonalName','name_tesim')
  	@dams_provenance_collection_parts=get_objects('DamsProvenanceCollectionPart','title_tesim')
  		
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
	@mads_complex_subjects = get_objects('MadsComplexSubject','name_tesim')
	@dams_provenance_collection_parts=get_objects('DamsProvenanceCollectionPart','title_tesim')
	@provenance_collection_part_id = @dams_object.provenanceCollectionPart.to_s.gsub(/.*\//,'')[0..9] if !@dams_object.provenanceCollectionPart.nil?
	@dams_units = get_objects('DamsUnit','unit_name_tesim')
  	@dams_assembled_collections = get_objects('DamsAssembledCollection','title_tesim')
  	@dams_provenance_collections = get_objects('DamsProvenanceCollection','title_tesim')
  	@mads_languages =  get_objects('MadsLanguage','name_tesim')
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
  	@complexSubject_id = @dams_object.subject.to_s.gsub(/.*\//,'')[0..9] if !@dams_object.subject.nil?
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
  	@dams_object.attributes = params[:dams_object] 
  	if @dams_object.save
  		redirect_to @dams_object, notice: "Object has been saved"
  		#redirect_to edit_dams_object_path(@dams_object), notice: "Object has been saved"
    else
      flash[:alert] = "Unable to save object"
      render :new
    end
  end
  
  def update
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
