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
end
