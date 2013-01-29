class DamsStatutesController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :index

  def show
    @statute = DamsStatute.find(params[:id])
  end

  def new

  end

  def edit

  end

  def create
    @dams_statute.attributes = params[:dams_statute]
    if @dams_statute.save
        redirect_to @dams_statute, notice: "Statute has been saved"
    else
      flash[:alert] = "Unable to save statute"
      render :new
    end
  end

  def update
    @dams_statute.attributes = params[:dams_statute]
    if @dams_statute.save
        redirect_to @dams_statute, notice: "Successfully updated statute"
    else
      flash[:alert] = "Unable to save statute"
      render :edit
    end
  end

  def index
    @statutes = DamsStatute.all
  end

end
