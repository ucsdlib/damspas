class MadsPersonalNamesController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :index

  def show
    @mads_personal_name = MadsPersonalName.find(params[:id])
  end

  def new
	
  end

  def edit

  end

  def create
    @mads_personal_name.attributes = params[:mads_personal_name]
    if @mads_personal_name.save
        redirect_to @mads_personal_name, notice: "Personal Name has been saved"
    else
      flash[:alert] = "Unable to save personal name"
      render :new
    end
  end

  def update
    @mads_personal_name.attributes = params[:mads_personal_name]
    if @mads_personal_name.save
        redirect_to @mads_personal_name, notice: "Successfully updated personal name"
    else
      flash[:alert] = "Unable to save personal name"
      render :edit
    end
  end

  def index
    @mads_personal_name = MadsPersonalName.all
  end


end
