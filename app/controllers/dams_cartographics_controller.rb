class DamsCartographicsController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :index

  def show
    @cartographic = DamsCartographic.find(params[:id])
  end

  def new

  end

  def edit

  end

  def create
    @dams_cartographic.attributes = params[:dams_cartographic]
    if @dams_cartographic.save
        redirect_to @dams_cartographic, notice: "Cartographic has been saved"
    else
      flash[:alert] = "Unable to save cartographic"
      render :new
    end
  end

  def update
    @dams_cartographic.attributes = params[:dams_cartographic]
    if @dams_cartographic.save
        redirect_to @dams_cartographic, notice: "Successfully updated cartographic"
    else
      flash[:alert] = "Unable to save cartographic"
      render :edit
    end
  end

  def index
    @cartographics = DamsCartographic.all
  end

end
