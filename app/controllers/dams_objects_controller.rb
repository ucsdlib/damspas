require 'net/http'
require 'json'

class DamsObjectsController < ApplicationController
  include Blacklight::Catalog
  include Dams::ControllerHelper
  include CatalogHelper
  load_and_authorize_resource
  skip_load_and_authorize_resource :only => [:show, :zoom, :dams5, :data, :rdf]
  DamsObjectsController.solr_search_params_logic += [:add_access_controls_to_solr_params]

  ##############################################################################
  # solr actions ###############################################################
  ##############################################################################
  def show
    # update session counter, then redirect to URL w/o counter param
    if params[:counter]
      session[:search][:counter] = params[:counter]
   
      # import solr config from catalog_controller and setup next/prev docs
      @blacklight_config = CatalogController.blacklight_config
	    setup_next_and_previous_documents  
    end

	  search_results = request.env["HTTP_REFERER"]
	  if (!search_results.nil? && search_results.include?("search"))
	    session[:search_results] = search_results
	    # import solr config from catalog_controller and setup next/prev docs
      @blacklight_config = CatalogController.blacklight_config
	    setup_next_and_previous_documents
    end 
   
	  
    # get metadata from solr
    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )

    @rdfxml = @document['rdfxml_ssi'] if !@document.nil?
    if @rdfxml == nil
      @rdfxml = "<rdf:RDF xmlns:dams='http://library.ucsd.edu/ontology/dams#'
          xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'
          rdf:about='#{Rails.configuration.id_namespace}#{params[:id]}'>
  <dams:error>content missing</dams:error>
</rdf:RDF>"
    end

    # redirect to collection path if it is a type of collection record
    arr_of_col = [ "DamsAssembledCollection",
                   "DamsProvenanceCollection", 
                   "DamsProvenanceCollectionPart"]

    if !@document.nil? && arr_of_col.include?(@document["active_fedora_model_ssi"])
      redirect_to dams_collection_path(params[:id])
      return
    end

    # enforce access controls
    if can? :show, @document
      collectionData = @document["collection_json_tesim"]
		
	  @collectionDocArray = Array.new
	  if !collectionData.nil? and collectionData.length > 0
	  	collectionData.each do |datum|
          collection = JSON.parse(datum)
		  collectionDoc = get_single_doc_via_search(1, {:q => "id:#{collection['id']}"} )
		  relatedResourceData = collectionDoc["related_resource_json_tesim"] unless collectionDoc.nil?
		  if !relatedResourceData.nil?
			relatedResourceData.each do |datum|
			  relatedResource = JSON.parse(datum)
			  if relatedResource['type'] != "hydra-afmodel"
			    @collectionDocArray << collectionDoc
				break
			  end			
			end
		  end
	    end
	  end

	  @relResourceHash = get_related_resources(@document)
	  
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @document }
        format.rdf { render xml: @rdfxml }
      end
    elsif !@document.nil? && @document['discover_access_group_ssim'].include?("public")
      respond_to do |format|
        format.html { render :metadata }
        format.json { render json: @document }
        format.rdf { render xml: @rdfxml }
      end
    else
      authorize! :show, @document # 403 forbidden
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
  
  def dams5
    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )
    authorize! :show, @document
    params[:xsl] = "dams5.xsl"
    data = get_html_data params, nil
    render :xml => data
  end 
  def data
    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )
    authorize! :show, @document
  	controller_path = dams_collection_path params[:id]
    data = get_html_data params, controller_path
    render :text => data
  end 
  def rdf
    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )
    authorize! :show, @document
    params[:xsl] = "normalize.xsl"
    data = get_html_data params, nil
    render :xml => data
  end 
  
end
