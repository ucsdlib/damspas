class DamsCollectionsController < ApplicationController
  include Blacklight::Catalog

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
    DamsCollectionsController.solr_search_params_logic += [:add_access_controls_to_solr_params]
    setup_next_and_previous_documents

    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )
  end
  def index
    @response, @document = get_search_results( {:q => "type_tesim:'Collection'", :rows => '200', :sort => 'title_ssi asc'}, {:fq => "-id:#{Rails.configuration.excluded_collections}"} )
    @response, @ProvenanceDocument = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:DamsProvenanceCollection"', :rows => 100, :sort => 'title_ssi asc' )
     @response, @AssembledDocument = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:DamsAssembledCollection"', :rows => 100, :sort => 'title_ssi asc' )
     
    end
end
