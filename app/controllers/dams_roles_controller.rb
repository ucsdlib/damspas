class DamsRolesController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :index

  def show
    @role = DamsRole.find(params[:id])
  end

  def new

  end

  def edit

  end

  def create
    @dams_role.attributes = params[:dams_role]
    @dams_role.vocabulary = "http://library.ucsd.edu/ark:/20775/bb14141414"
    if @dams_role.save
        redirect_to @dams_role, notice: "Role has been saved"
    else
      flash[:alert] = "Unable to save role"
      render :new
    end
  end

  def update
    @dams_role.attributes = params[:dams_role]
    if @dams_role.save
        redirect_to @dams_role, notice: "Successfully updated role"
    else
      flash[:alert] = "Unable to save role"
      render :edit
    end
  end

  def index
    @roles = DamsRole.all
  end


end
