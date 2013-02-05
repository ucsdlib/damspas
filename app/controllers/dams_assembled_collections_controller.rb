class DamsAssembledCollectionsController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :index

  def show
    @dams_assembled_collection = DamsAssembledCollection.find(params[:id])
  end

  def new

  end

  def edit

  end

  def create
    @dams_assembled_collection.attributes = params[:dams_assembled_collection]
    if @dams_assembled_collection.save
        redirect_to @dams_assembled_collection, notice: "AssembledCollection has been saved"
    else
      flash[:alert] = "Unable to save assembled_collection"
      render :new
    end
  end

  def update
    @dams_assembled_collection.attributes = params[:dams_assembled_collection]
    if @dams_assembled_collection.save
        redirect_to @dams_assembled_collection, notice: "Successfully updated assembled_collection"
    else
      flash[:alert] = "Unable to save assembled_collection"
      render :edit
    end
  end

  def index
    @units = DamsAssembledCollection.all( :order=>"system_create_dtsi asc" )
  end


end
