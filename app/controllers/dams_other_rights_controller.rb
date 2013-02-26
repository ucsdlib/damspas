class DamsOtherRightsController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :index

  def show
    @other_rights = DamsOtherRights.find(params[:id])
  end

  def new

  end

  def edit

  end

  def create
    @dams_other_rights.attributes = params[:dams_other_rights]
    if @dams_other_rights.save
        redirect_to @dams_other_rights, notice: "OtherRights has been saved"
    else
      flash[:alert] = "Unable to save other_rights"
      render :new
    end
  end

  def update
    @dams_other_rights.attributes = params[:dams_other_rights]
    if @dams_other_rights.save
        redirect_to @dams_other_rights, notice: "Successfully updated other_rights"
    else
      flash[:alert] = "Unable to save other_rights"
      render :edit
    end
  end

  def index
    @other_rights = DamsOtherRights.all
  end

end
