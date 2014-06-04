class DamsCollectionsController < ApplicationController
  include Blacklight::Catalog
  include Dams::ControllerHelper
  DamsCollectionsController.solr_search_params_logic += [:add_access_controls_to_solr_params]

  def show
    # update session counter, then redirect to URL w/o counter param
    if params[:counter]
      session[:search][:counter] = params[:counter]
      redirect_to dams_collection_path(params[:id])
      return
    end

    # import solr config from catalog_controller and setup next/prev docs
    @blacklight_config = CatalogController.blacklight_config
    setup_next_and_previous_documents

    # fetch collection record from solr
    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )

    @rdfxml = @document['rdfxml_ssi']
    if @rdfxml == nil
      @rdfxml = "<rdf:RDF xmlns:dams='http://library.ucsd.edu/ontology/dams#'
          xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'
          rdf:about='#{Rails.configuration.id_namespace}#{params[:id]}'>
  <dams:error>content missing</dams:error>
</rdf:RDF>"
    end
         if can? :show, @document
      collectionData = @document["collection_json_tesim"]
    
    @collectionDocArray = Array.new
    if !collectionData.nil? && collectionData.length > 0
      collectionData.each do |datum|
          collection = JSON.parse(datum)
      collectionDoc = get_single_doc_via_search(1, {:q => "id:#{collection['id']}"} )
      relatedResourceData = collectionDoc["related_resource_json_tesim"]

      relatedResourceData.each do |datum|
      relatedResource = JSON.parse(datum)
      if relatedResource['type'] != "hydra-afmodel"
        @collectionDocArray << collectionDoc
        break
      end     
      end
      end
    end

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
  
  def data_view
      controller_path = dams_collection_path params[:id]
      data = get_html_data params, controller_path
      render :text => data
  end
  
end
