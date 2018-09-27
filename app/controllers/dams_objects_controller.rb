class DamsObjectsController < DamsResourceController
  DamsObjectsController.solr_search_params_logic += [:add_access_controls_to_solr_params]

  def check_type(document)
    # redirect to collection path if it is a type of collection record
    arr_of_col = ['DamsAssembledCollection', 'DamsProvenanceCollection', 'DamsProvenanceCollectionPart']

    if !document.nil? && arr_of_col.include?(document["active_fedora_model_ssi"])
      return dams_collection_path(params[:id])
    end
  end

  def find_linked_documents(document)
    @relResourceHash = get_related_resources(document)
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

  # EMBED UI
  def embed
    response.headers.delete 'X-Frame-Options'

    # get metadata from solr
    @document = get_single_doc_via_search(1, q: "id:#{params[:id]}")

    # enforce access controls
    authorize! :show, @document

    @object = params[:id]
    @component = params[:cmp]

    render layout: 'stand_alone_video_player'
  end
  # EMBED UI END
end
