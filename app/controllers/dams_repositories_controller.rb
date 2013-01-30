class DamsRepositoriesController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :index

  def show
    @repository = DamsRepository.find(params[:id])
  end

  def new

  end

  def edit

  end

  def create
    @dams_repository.attributes = params[:dams_repository]
    if @dams_repository.save
        redirect_to @dams_repository, notice: "Repository has been saved"
    else
      flash[:alert] = "Unable to save repository"
      render :new
    end
  end

  def update
    @dams_repository.attributes = params[:dams_repository]
    if @dams_repository.save
        redirect_to @dams_repository, notice: "Successfully updated repository"
    else
      flash[:alert] = "Unable to save repository"
      render :edit
    end
  end

  def index
    @repositories = DamsRepository.all( :order=>"system_create_dtsi asc" )
  end


end
