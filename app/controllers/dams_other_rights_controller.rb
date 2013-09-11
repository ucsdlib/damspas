class DamsOtherRightsController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :index

  def show
    @other_rights = DamsOtherRight.find(params[:id])
  end

  def new

  end

  def edit

  end

  def create
    @dams_other_right.attributes = params[:dams_other_right]
    if @dams_other_right.save
        redirect_to @dams_other_right, notice: "OtherRights has been saved"
    else
      flash[:alert] = "Unable to save OtherRights"
      render :new
    end
  end

  def update
    @dams_other_right.attributes = params[:dams_other_right]
    if @dams_other_right.save
        redirect_to @dams_other_right, notice: "Successfully updated OtherRights"
    else
      flash[:alert] = "Unable to save OtherRights"
      render :edit
    end
  end

  def index
    @other_rights = DamsOtherRight.all
  end

end
