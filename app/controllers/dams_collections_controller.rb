class DamsCollectionsController < DamsResourceController
  DamsCollectionsController.solr_search_params_logic += [:add_access_controls_to_solr_params]

  def check_type( document )
    if !document.nil? && document["active_fedora_model_ssi"].include?("DamsObject") 
      return dams_object_path(params[:id])
    end
  end

  def find_linked_documents( document )
    # find objects that are part of this collection
    q = "collection_sim:\"#{document['title_tesim'].first}\""
    (object_response, object_list) = get_search_results :q => q
    @object_count = object_response.total
  end

  def index
    @response, @document = get_search_results(:q => 'type_tesim:Collection', :rows => 100 )
  end

end
