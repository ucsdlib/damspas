class DamsCartographicsController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :index

  def show
    @cartographic = DamsCartographics.find(params[:id])
  end
  
  def index
    @cartographics = DamsCartographics.all
  end

end
