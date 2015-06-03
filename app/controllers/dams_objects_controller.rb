class DamsObjectsController < DamsResourceController
  DamsObjectsController.solr_search_params_logic += [:add_access_controls_to_solr_params]

  def check_type( document )
    # redirect to collection path if it is a type of collection record
    arr_of_col = [ "DamsAssembledCollection",
                   "DamsProvenanceCollection", 
                   "DamsProvenanceCollectionPart"]

    if !document.nil? && arr_of_col.include?(document["active_fedora_model_ssi"])
      return dams_collection_path(params[:id])
    end
  end

  def find_linked_documents( document )
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

  def edit

    # get metadata from solr
    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )

    # enforce access controls
    authorize! :edit, @document

    @format = params[:format].blank? ? 'xml' : params[:format]
    @data = get_data false, @format
    @edit_form = DamsObject.find(pid: params[:id])
  end

  def update
    # get metadata from solr
    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )

    # enforce access controls
    authorize! :edit, @document

    begin
        @damsObj = DamsObject.find(pid: params[:id]).first
        @damsObj.damsMetadata.content = params[:dams_object]['damsMetadata']

        if @damsObj.save!
          flash[:notice] = 'Update Successfully!'
          redirect_to dams_object_path
          return
        else
          flash[:alert] = "Failed to update record: " + @damsObj.errors.full_messages.map { |s| s.to_s }.join(", ")
        end
    rescue Exception => e
      err = e.to_s
      if (!err.downcase.index('400 bad request').nil?)
        flash[:error] = 'Error status code ' + err + ': ' + 'Invalid RDF Input.'
      else
        flash[:error] = "Failed to update record: " + err
      end 
    end

    redirect_to edit_path
  end

end
