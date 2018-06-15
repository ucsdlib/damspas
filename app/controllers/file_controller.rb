class FileController < ApplicationController
  include Blacklight::Catalog
  include Dams::ControllerHelper

  def show
    # load metadata
    start = Time.now.to_f
    begin
      objid = params[:id]
      fileid = params[:ds]
      if fileid.index("_",1)
        cmp_part = fileid[1,fileid.index("_",1)-1]
        file_part = fileid[fileid.index("_",1)+1,fileid.length]
      else
        cmp_part = nil
        file_part = fileid[1,fileid.length]
      end
      prefix = cmp_part ? "component_#{cmp_part}_" : ""
      field = "#{prefix}files_tesim"

      @solr_doc = get_single_doc_via_search(1, {:q => "id:#{objid}", :fl => "#{field},read_access_group_ssim,edit_access_group_ssim,discover_access_group"} )
      asset = ActiveFedora::Base.load_instance_from_solr(objid,@solr_doc)
    rescue
      raise ActionController::RoutingError.new('Not Found')
    end
    ds = asset.datastreams[fileid]
    if ds.nil?
      raise ActionController::RoutingError.new('Not Found')
    end

    # load use value from solr
    use = "image-source" # default use to source, which requires curator privs
    file_json = @solr_doc[field]
    file_json.each do |json|
      file_info = JSON.parse(json)
      if file_info["id"] == file_part
        use = file_info["use"]
      end
    end

    # check permissions
    if use.end_with?("source")
      logger.info "FileController: Master file access requires edit permission"
      authorize! :edit, @solr_doc
    elsif !@solr_doc['read_access_group_ssim'].include?("public")
      authorize! :show, @solr_doc
      raise CanCan::AccessDenied, "Download forbidden: /#{objid}/#{fileid}" unless can?(:edit, @solr_doc) || can_download?(@solr_doc, fileid)
    end

    # set headers
    disposition = params[:disposition] || 'inline'
    filename = params["filename"] || "#{objid}#{fileid}"
    file_type = http_content_type(ds, filename)

    # hand off to nginx
    logger.info "Sending file #{Rails.configuration.sendfile_prefix + filename} to nginx"
    send_file(Rails.configuration.sendfile_prefix + filename,
              type: file_type,
              disposition: disposition,
              x_sendfile: true)
  end

  def create
    # load object and check authorization
    @obj = ActiveFedora::Base.find(params[:id], :cast=>true)
    authorize! :edit, @obj

    # attach the file and redirect to view page
    status = attach_file( @obj, params[:file] )
    flash[:alert] = status[:alert] if status[:alert]
    flash[:notice] = status[:notice] if status[:notice]
    flash[:deriv] = status[:deriv] if status[:deriv]
    redirect_to dams_object_path @obj
  end
  def deriv
    begin
      @obj = params[:id]
      dspart = params[:ds].split("_")
      if ( dspart.length == 2 )
        @cid = nil
        @fid = dspart[1]
      elsif ( dspart.length == 3 )
        @cid = dspart[1]
        @fid = dspart[2]
      else
        redirect_to dams_object_path @obj, notice: "Invalid datastream name: #{params[:ds]}"
        return
      end

      # add any extension stripped by rails
      ext = File.extname(request.fullpath)
      @fid += ext unless ext.nil?

      # build url to make damsrepo generate derivs
      url = "#{dams_api_path}/api/files/#{@obj}/"
      url += "#{@cid}/" unless @cid.nil?
      url += "#{@fid}/derivatives?format=json"

      # call damsrepo
      json = dams_post url
      if json['status'] == 'OK'
        flash[:notice] = json['message']
      else
        flash[:alert] = json['message']
      end

      # update solr index
      @fobj = DamsObject.find( @obj )
      @fobj.send :update_index

      redirect_to dams_object_path @obj
    rescue Exception => e
      logger.warn "Error generating derivatives #{e.to_s}"
      flash[:alert] = e.to_s
      redirect_to dams_object_path @obj
    end
  end

  private
  # Determine http content type for a file download
  # We have added our own localized logic when a mimeType doesn't exist, such as checking the filename suffix for xml
  # files. This ideally should not be necessary.
  def http_content_type(datastream, filename)
    return 'application/octet-stream' unless datastream && filename

    if datastream.mimeType
      datastream.mimeType
    elsif filename.include?('.xml')
      'application/xml'
    else
      'application/octet-stream'
    end
  end
end
