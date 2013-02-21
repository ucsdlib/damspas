class DamsPersonalNamesController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :index

  def show
    @personal_name = DamsPersonalName.find(params[:id])
  end

  def new

  end

  def edit

  end

  def create
    @dams_personal_name.attributes = params[:dams_personal_name]
    if @dams_personal_name.save
        redirect_to @dams_personal_name, notice: "Personal Name has been saved"
    else
      flash[:alert] = "Unable to save personal name"
      render :new
    end
  end

  def update
    @dams_personal_name.attributes = params[:dams_personal_name]
    if @dams_personal_name.save
        redirect_to @dams_personal_name, notice: "Successfully updated personal name"
    else
      flash[:alert] = "Unable to save personal name"
      render :edit
    end
  end

  def index
    @dams_personal_names = DamsPersonalName.all
  end
end
