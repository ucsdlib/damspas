class DamsCopyrightsController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :index

  def show
    @copyright = DamsCopyright.find(params[:id])
  end

  def new

  end

  def edit

  end

  def create
    @dams_copyright.attributes = params[:dams_copyright]
    if @dams_copyright.save
        redirect_to @dams_copyright, notice: "Copyright has been saved"
    else
      flash[:alert] = "Unable to save copyright"
      render :new
    end
  end

  def update
    @dams_copyright.attributes = params[:dams_copyright]
    if @dams_copyright.save
        redirect_to @dams_copyright, notice: "Successfully updated copyright"
    else
      flash[:alert] = "Unable to save copyright"
      render :edit
    end
  end

  def index
    @copyrights = DamsCopyright.all
  end


end
