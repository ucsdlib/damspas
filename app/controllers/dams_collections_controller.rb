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

    # fetch collection record from solr
    @document = get_single_doc_via_search(1, {:q => "id_t:#{params[:id]}"} )

    # import solr config from catalog_controller and setup next/prev docs
    @blacklight_config = CatalogController.blacklight_config
    DamsCollectionsController.solr_search_params_logic += [:add_access_controls_to_solr_params]
    setup_next_and_previous_documents
  end
end
