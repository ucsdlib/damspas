class FileController < ApplicationController

  def show
    # load metadata
    begin
      asset = ActiveFedora::Base.find(params[:id], :cast=>true)
    rescue
      raise ActionController::RoutingError.new('Not Found')
    end
    ds = asset.datastreams[params[:ds]]
    if ds.nil?
      raise ActionController::RoutingError.new('Not Found')
    end

    # set headers
    filename = params["filename"] || "#{params[:id]}#{params[:ds]}"
    headers['Content-Disposition'] = "inline; filename=#{filename}"
    headers['Content-Type'] = ds.mimeType || 'application/octet-stream'
    headers['Last-Modified'] = ds.lastModifiedDate || Time.now.ctime.to_s
    if ds.size
      headers['Content-Length'] = ds.size.to_s
    else
      headers['Transfer-Encoding'] = 'chunked'
    end

    # see https://github.com/cul/active_fedora_streamable/blob/master/lib/active_fedora_streamable.rb

    # stream data to client (does not work in webrick)
    parms = { :pid => params[:id], :dsid => params[:ds], :finished=>false }
    repo = ActiveFedora::Base.connection_for_pid(parms[:pid])
    self.response_body = Enumerator.new do |blk|
      repo.datastream_dissemination(parms) do |res|
        res.read_body do |seg|
          blk << seg
        end
      end
    end
  end

  def create
    @id = params[:id]
    file = params[:file] if params[:file].respond_to?(:original_filename)
    if file.nil?
      flash[:alert] = "No file upload found"
      redirect_to view_dams_object_path @id
      return
    end

    @ds = "_1" # TODO list ds and get next ds #
    ext = File.extname(file.original_filename)
    @ds += ext unless ext.nil?
    @obj = ActiveFedora::Base.find(@id, :cast=>true)
    @obj.add_file( file, @ds, file.original_filename )
    @obj.save!
    flash[:notice] = "File Uploaded"

    # if a file is audio, image or video, render view with link to generate
    # derivatives, otherwise, just go back to the object view
    mt = file.content_type
    if !mt.include?("audio") && !mt.include?("image") && !mt.include?("video")
      redirect_to view_dams_object_path @obj, notice: "File Uploaded"
      return
    end
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
        redirect_to view_dams_object_path @obj, notice: "Invalid datastream name: #{params[:ds]}"
        return
      end

      # add any extension stripped by rails
      ext = File.extname(request.fullpath)
      @fid += ext unless ext.nil?

      # build url to make damsrepo generate derivs
      user = ActiveFedora.fedora_config.credentials[:user]
      pass = ActiveFedora.fedora_config.credentials[:password]
      baseurl = ActiveFedora.fedora_config.credentials[:url]
      baseurl = baseurl.gsub(/\/fedora$/,'')
      url = "#{baseurl}/api/files/#{@obj}/"
      url += "#{@cid}/" unless @cid.nil?
      url += "#{@fid}/derivatives?format=json"

      # call damsrepo
      response = RestClient::Request.new(
        :method => :post, :url => url, :user => user, :password => pass
      ).execute
      json = JSON.parse(response.to_str)
      if json['status'] == 'OK'
        flash[:notice] = json['message']
      else
        flash[:alert] = json['message']
      end

      # update solr index
      @fobj = DamsObject.find( @obj )
      @fobj.send :update_index

      redirect_to view_dams_object_path @obj
    rescue Exception => e
      logger.warn "Error generating derivatives #{e.to_s}"
      flash[:alert] = e.to_s
      redirect_to view_dams_object_path @obj
    end
  end
end
