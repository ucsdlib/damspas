class FileController < ApplicationController
  def show
    asset = ActiveFedora::Base.find(params[:id], :cast=>true)
    opts = {}
    ds = asset.datastreams[params[:ds]]
    opts[:filename] = params["filename"] || asset.label
    opts[:disposition] = 'inline'
    opts[:type] = ds.mimeType
    send_data ds.content, opts
    return
  end
end
