class DamsCollectionsController < ApplicationController
  include Blacklight::Catalog
  DamsCollectionsController.solr_search_params_logic += [:add_access_controls_to_solr_params]

  def show
    # update session counter, then redirect to URL w/o counter param
    if params[:counter]
      session[:search][:counter] = params[:counter]
      redirect_to dams_collection_path(params[:id])
      return
    end

    # check ip for unauthenticated users
    if current_user == nil
      current_user = User.anonymous(request.ip)
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

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @document }
      format.rdf { render xml: @rdfxml }
    end
  end
end
