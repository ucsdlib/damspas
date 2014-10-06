class DamsSourceCapturesController < ApplicationController
  include Dams::ControllerHelper
  load_and_authorize_resource
  skip_authorize_resource :only => :index

  def show
    @dams_source_capture = DamsSourceCapture.find(params[:id])  
  end
 
  def index
    @source_captures = DamsSourceCapture.all
  end
end
