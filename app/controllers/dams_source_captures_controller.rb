class DamsSourceCapturesController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :index

  def show
    @dams_source_capture = DamsSourceCapture.find(params[:id])  
  end

  def new
	
  end

  def edit

  end

  def create
    @dams_source_capture.attributes = params[:dams_source_capture]

    if @dams_source_capture.save
        redirect_to @dams_source_capture, notice: "Source Capture has been saved"
    else
      flash[:alert] = "Unable to save source capture"
      render :new
    end
  end

  def update
    @dams_source_capture.attributes = params[:dams_source_capture]
    if @dams_source_capture.save
        redirect_to @dams_source_capture, notice: "Successfully updated source capture"
    else
      flash[:alert] = "Unable to save source capture"
      render :edit
    end
  end

  def index
    @source_captures = DamsSourceCapture.all
  end


end
